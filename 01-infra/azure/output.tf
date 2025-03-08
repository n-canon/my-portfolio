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
