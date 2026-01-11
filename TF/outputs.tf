output "frontend_public_ip" {
  value = module.compute.frontend_public_ip
}

output "ssh_command" {
  value = "ssh -i myserver_key.pem azureuser@${module.compute.frontend_public_ip}"
}