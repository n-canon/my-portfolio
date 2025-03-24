output "rgname" {
  description = "Ressource group name"
  value       = azurerm_resource_group.rg_nca_data_project.name
}


output "adfname" {
  description = "Azure Data factory name"
  value       = azurerm_data_factory.datafactory.name
}


output "rglocation" {
  description = "Location value"
  value       = azurerm_resource_group.rg_nca_data_project.location
}

output "functionname" {
  description = "Function name"
  value       = azurerm_linux_function_app.function.name
}

output "kvname" {
  description = "KeyVault name"
  value       = azurerm_key_vault.keyvault.name
}

output "blobname" {
  description = "Blob storage name"
  value       = azurerm_storage_account.storage.name
}


output "blobconnectionstring" {
  description = "Blob storage connection string"
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

