# 1. Call the Network Module
module "network" {
  source              = "./modules/network"
  resource_group_name = var.resource_group_name
  location            = var.location
  vnet_address_space  = var.vnet_address_space
}

# 2. Call the Compute Module
module "compute" {
  source              = "./modules/compute"
  resource_group_name = module.network.resource_group_name # Bilgiyi network modülünden alıyor
  location            = module.network.location
  
  # Dependency Injection: Network modülünün çıktısını Compute'a girdi olarak veriyoruz
  frontend_subnet_id  = module.network.frontend_subnet_id
  backend_subnet_id   = module.network.backend_subnet_id
}