
##################################
# PROVIDER
##################################
provider "azurerm" {
}

provider "azuread" {
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-infra-test-nca"
    storage_account_name = "stterraformtestnca"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}

##################################
# LOCAL VARIABLES
##################################
locals {
  secrets= csvdecode(file("/secrets/secret.csv"))

  containers= csvdecode(file("/containers/containers.csv"))
}


##################################
# RESSOURCE GROUP
##################################
resource "azurerm_resource_group" "rg_nca_data_project" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = "${var.location}"
}


##################################
# STORAGE ACCOUNT
##################################
resource "azurerm_storage_account" "storage" {
  name                     = "st-${var.project_name}-${var.environment}"
  resource_group_name      = azurerm_resource_group.rg_nca_data_project.name
  location                 = azurerm_resource_group.rg_nca_data_project.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  https_traffic_only_enabled = true
  shared_access_key_enabled = false
  is_hsn_enabled = true

  tags = {
    environment = "${var.environment}"
  }
}


resource "azurerm_storage_container" "containers" {
  for_each = { for container in local.containers : container["container"] => container}
  name                  = each.value.container
  storage_account_id    = azurerm_storage_account.example.id
  container_access_type = "private"

  depends_on = [
    azurerm_storage_account.storage
  ]
}

##################################
# DATABASE
##################################
resource "azurerm_mssql_server" "sql-server" {
  name                         = "sqlsrv-${var.project_name}-${var.environment}"
  resource_group_name          = azurerm_resource_group.rg_nca_data_project.name
  location                     = azurerm_resource_group.rg_nca_data_project.location
  version                      = "12.0"
  administrator_login          = "${var.sql_admin_user}"
  administrator_login_password = "${var.VAR_SQL_ADMIN_PASSWORD}"

    tags = {
    environment = "${var.environment}"
  }
}

resource "azurerm_mssql_database" "sql-database" {
  name         = "sqldb-${var.project_name}-${var.environment}"
  server_id    = azurerm_mssql_server.example.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  license_type = "BasePrice"
  max_size_gb  = 2
  sku_name     = "S0"

  tags = {
    environment = "${var.environment}"
  }

  lifecycle {
    prevent_destroy = true
  }
}

##################################
# AZURE FONCTION
##################################
resource "azurerm_linux_function_app" "function" {
  name                = "func-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.rg_nca_data_project.name
  location            = azurerm_resource_group.rg_nca_data_project.location
  storage_account_name       = azurerm_storage_account.storage.name
  service_plan_id            = null

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "python" 
    "AzureWebJobsStorage"      = azurerm_storage_account.storage.primary_connection_string
  }

  tags = {
      environment = "${var.environment}"
  }

  site_config {}

    depends_on = [
    azurerm_storage_account.storage
  ]
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
  sku_name = "standard"

    tags = {
    environment = "${var.environment}"
  }
}


##################################
# DATABRICKS
##################################

resource "azurerm_databricks_workspace" "databricks" {
  name                = "dbw-${var.project_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"

  tags = {
    environment = "${var.environment}"
  }
}