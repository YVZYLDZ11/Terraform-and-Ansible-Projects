terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# ==========================================
# 1. NETWORKS (VNETs & SUBNETs)
# ==========================================

# MAIN HQ NETWORK (Everything goes here)
module "hq_network" {
  source             = "./modules/core_network"
  rg_name            = "F1-HQ-Main-RG"
  location           = "France Central"
  vnet_address_space = ["10.0.0.0/16"]
  subnet_prefixes    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24"]
}

# MONACO TRACK NETWORK
module "monaco_network" {
  source             = "./modules/core_network"
  rg_name            = "F1-Monaco-Track-RG"
  location           = "France Central"
  vnet_address_space = ["10.1.0.0/16"]
  subnet_prefixes    = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24"]
}

# SILVERSTONE TRACK NETWORK (Student account safe region)
module "silverstone_network" {
  source             = "./modules/core_network"
  rg_name            = "F1-Silverstone-Track-RG"
  location           = "Switzerland North"
  vnet_address_space = ["10.2.0.0/16"]
  subnet_prefixes    = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24", "10.2.4.0/24"]
}

# ==========================================
# 2. STORAGE ACCOUNTS (DATA LAKES)
# ==========================================

# Telemetry Data Lake (Attached to HQ)
module "hq_telemetry_storage" {
  source       = "./modules/storage_account"
  storage_name = "f1datahq2026yavuz" # CHANGE THIS! (Lowercase letters and numbers only, must be globally unique)
  rg_name      = "F1-HQ-Main-RG"
  location     = "France Central"
  depends_on   = [module.hq_network] # Ensure HQ Resource Group is created before this module
}

# Backup Storage
module "hq_backup_storage" {
  source       = "./modules/storage_account"
  storage_name = "f1backup2026yavuz" # CHANGE THIS! (Lowercase letters and numbers only, must be globally unique)
  rg_name      = "F1-HQ-Main-RG"
  location     = "France Central"
  depends_on   = [module.hq_network]
}

# ==========================================
# 3. VNET PEERINGS (FIBER OPTIC CABLES)
# ==========================================

# --- HQ <-> MONACO CONNECTION ---

# 1. Cable from HQ to Monaco
resource "azurerm_virtual_network_peering" "hq_to_monaco" {
  name                      = "HQ-to-Monaco-Peering"
  resource_group_name       = module.hq_network.rg_name
  virtual_network_name      = module.hq_network.vnet_name
  remote_virtual_network_id = module.monaco_network.vnet_id
}

# 2. Cable from Monaco to HQ
resource "azurerm_virtual_network_peering" "monaco_to_hq" {
  name                      = "Monaco-to-HQ-Peering"
  resource_group_name       = module.monaco_network.rg_name
  virtual_network_name      = module.monaco_network.vnet_name
  remote_virtual_network_id = module.hq_network.vnet_id
}

# --- HQ <-> SILVERSTONE CONNECTION ---

# 3. Cable from HQ to Silverstone
resource "azurerm_virtual_network_peering" "hq_to_silverstone" {
  name                      = "HQ-to-Silverstone-Peering"
  resource_group_name       = module.hq_network.rg_name
  virtual_network_name      = module.hq_network.vnet_name
  remote_virtual_network_id = module.silverstone_network.vnet_id
}

# 4. Cable from Silverstone to HQ
resource "azurerm_virtual_network_peering" "silverstone_to_hq" {
  name                      = "Silverstone-to-HQ-Peering"
  resource_group_name       = module.silverstone_network.rg_name
  virtual_network_name      = module.silverstone_network.vnet_name
  remote_virtual_network_id = module.hq_network.vnet_id
}


# ==========================================
# DATA SOURCES (Fetch info from Azure dynamically)
# ==========================================

# Get the current logged-in user's identity (Your Azure Account)
data "azurerm_client_config" "current" {}

# ==========================================
# 3. SECURITY & SECRETS MANAGEMENT
# ==========================================

# Main F1 Key Vault
module "hq_key_vault" {
  source     = "./modules/key_vault"
  kv_name    = "f1vault2026yavuz" # CHANGE THIS! (Must be globally unique, lowercase letters and numbers only, no spaces)
  rg_name    = "F1-HQ-Main-RG"
  location   = "France Central"
  
  # Pass the dynamic IDs fetched from the data source
  tenant_id  = data.azurerm_client_config.current.tenant_id
  object_id  = data.azurerm_client_config.current.object_id

  depends_on = [module.hq_network]
}