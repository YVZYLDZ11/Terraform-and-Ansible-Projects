# Create an Azure Storage Account for F1 Data
resource "azurerm_storage_account" "f1_storage" {
  name                     = var.storage_name
  resource_group_name      = var.rg_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Local Redundant Storage (Cheapest for student account)
}