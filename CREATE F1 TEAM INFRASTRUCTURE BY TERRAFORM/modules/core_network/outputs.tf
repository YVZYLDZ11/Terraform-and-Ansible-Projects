# The ID of the Virtual Network (Required for Peering)
output "vnet_id" {
  description = "The ID of the Virtual Network"
  value       = azurerm_virtual_network.f1_vnet.id
}

# The Name of the Virtual Network
output "vnet_name" {
  description = "The Name of the Virtual Network"
  value       = azurerm_virtual_network.f1_vnet.name
}

# The Name of the Resource Group
output "rg_name" {
  description = "The Name of the Resource Group"
  value       = azurerm_resource_group.f1_rg.name
}