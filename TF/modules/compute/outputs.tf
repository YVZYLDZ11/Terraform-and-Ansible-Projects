output "frontend_public_ip" {
  value = azurerm_public_ip.pip_frontend.ip_address
}

output "backend_private_ip" {
  value = azurerm_network_interface.nic_backend.private_ip_address
}