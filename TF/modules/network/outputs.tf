output "resource_group_name" {
  value = azurerm_resource_group.main_rg.name
}

output "location" {
  value = azurerm_resource_group.main_rg.location
}

output "frontend_subnet_id" {
  value = azurerm_subnet.subnet_frontend.id
}

output "backend_subnet_id" {
  value = azurerm_subnet.subnet_backend.id
}