terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

 # Backend configuration (Stores the state file in Azure)
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstore11"        
    container_name       = "tfstate-files"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}