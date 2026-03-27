variable "storage_name" {
  description = "Name of the Storage Account (MUST BE GLOBALLY UNIQUE, lowercase, no spaces)"
  type        = string
}

variable "rg_name" {
  description = "Resource Group Name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}