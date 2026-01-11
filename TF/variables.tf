variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "France Central"
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rg-two-tier-demo"
}

variable "vnet_address_space" {
  description = "Address space for the Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}