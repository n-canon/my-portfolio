##################################
# PROVIDER
##################################
provider "azurerm" {
  features {}
}

provider "azuread" {}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-infra-test-nca"
    storage_account_name = "stterraformtestnca"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}


##################################
# GROUP
##################################
data "azuread_group" "dev_group" {
  display_name     = var.developers_group
  security_enabled = true
}

##################################
# LOCAL VARIABLES
##################################
locals {
  secrets    = csvdecode(file("${path.module}/secrets/secrets.csv"))
  containers = csvdecode(file("${path.module}/containers/containers.csv"))
}

data "azurerm_client_config" "current" {}

##################################
# RESOURCE GROUP
##################################
resource "azurerm_resource_group" "rg_nca_data_project" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
  }
}

##################################
# STORAGE ACCOUNT
##################################
resource "azurerm_storage_account" "storage" {
  name                       = "st${var.project_name}${var.environment}"
  resource_group_name        = azurerm_resource_group.rg_nca_data_project.name
  location                   = azurerm_resource_group.rg_nca_data_project.location
  account_kind               = "StorageV2"
  account_tier               = "Standard"
  account_replication_type   = "GRS"
  https_traffic_only_enabled = true
  shared_access_key_enabled  = true
  is_hns_enabled             = true

  tags = {
    environment = var.environment
  }
}

resource "azurerm_storage_container" "containers" {
  for_each              = { for container in local.containers : container["container"] => container }
  name                  = each.value.container
  storage_account_id    = azurerm_storage_account.storage.id
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.storage
  ]

}

## ACCESS

resource "azurerm_role_assignment" "dev_st_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_group.dev_group.object_id
}


##################################
# DATABASE
##################################
resource "azurerm_mssql_server" "sql_server" {
  name                         = "sqlsrv-${var.project_name}-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg_nca_data_project.name
  location                     = azurerm_resource_group.rg_nca_data_project.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_user
  administrator_login_password = var.sql_admin_password

  tags = {
    environment = var.environment
  }
}

resource "azurerm_mssql_database" "sql-database" {
  name         = "sqldb-${var.project_name}-${var.environment}"
  server_id    = azurerm_mssql_server.sql_server.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  max_size_gb  = 2
  sku_name     = "S0"

  tags = {
    environment = var.environment
  }

  lifecycle {
    prevent_destroy = true
  }
}

##################################
# AZURE FUNCTION
##################################
resource "azurerm_linux_function_app" "function" {
  name                       = "func-${var.project_name}-${var.environment}"
  resource_group_name        = azurerm_resource_group.rg_nca_data_project.name
  location                   = azurerm_resource_group.rg_nca_data_project.location
  storage_account_name       = azurerm_storage_account.storage.name
  storage_account_access_key = azurerm_storage_account.storage.primary_access_key
  service_plan_id            = azurerm_service_plan.service_plan.id
  https_only                 = true



  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python"
    "AzureWebJobsStorage"      = azurerm_storage_account.storage.primary_connection_string
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
  }



  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  depends_on = [
    azurerm_storage_account.storage, azurerm_service_plan.service_plan
  ]
}

resource "azurerm_service_plan" "service_plan" {
  name                = "sp-linux-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
  sku_name            = "Y1"
  os_type             = "Linux"

  tags = {
    environment = var.environment
  }
}


## Access #######
resource "azurerm_role_assignment" "function_to_storage_access" {
  scope                = azurerm_storage_account.storage.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_linux_function_app.function.identity[0].principal_id
}


##################################
# KEYVAULT
##################################
resource "azurerm_key_vault" "keyvault" {
  name                        = "kv-${var.project_name}-${var.environment}"
  location                    = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name         = azurerm_resource_group.rg_nca_data_project.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  tags = {
    environment = var.environment
  }
}


resource "azurerm_role_assignment" "function_to_keyvault_access" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_linux_function_app.function.identity[0].principal_id
}


##################################
# DATABRICKS
##################################
#resource "azurerm_databricks_workspace" "databricks" {
#  name                = "dtb-${var.project_name}-${var.environment}"
#  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
#  location            = azurerm_resource_group.rg_nca_data_project.location
#  sku                 = "trial"
#
#  tags = {
#    environment = var.environment
#  }
#}


#################################
# DATA FACTORY
#################################
resource "azurerm_data_factory" "datafactory" {
  name                = "adf-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = var.environment
  }
}

data "azuread_service_principal" "data_factory_managed_identity" {
  object_id = azurerm_data_factory.datafactory.identity.0.principal_id
}


resource "azurerm_role_assignment" "adf_to_function_access" {
  scope                = azurerm_linux_function_app.function.id
  role_definition_name = "Reader"
  principal_id         = data.azuread_service_principal.data_factory_managed_identity.object_id
  depends_on = [ azurerm_data_factory.datafactory ]
}


#################################
# EVENT HUB
#################################
resource "azurerm_eventhub_namespace" "eventhub" {
  name                = "evh-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
  sku                 = "Basic"
  capacity            = 1

  tags = {
    environment = var.environment
  }
}


#################################
# SERVICE BUS
#################################

resource "azurerm_servicebus_namespace" "servicebus" {
  name                = "sb-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
  sku                 = "Basic"

  tags = {
    environment = var.environment
  }
}


#################################
# APPLICATION INSIGHTS
#################################

resource "azurerm_application_insights" "appinsights" {
  name                = "ai-${var.project_name}-${var.environment}"
  location            = azurerm_resource_group.rg_nca_data_project.location
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
  application_type    = "web"

  tags = {
    environment = var.environment
  }
}

