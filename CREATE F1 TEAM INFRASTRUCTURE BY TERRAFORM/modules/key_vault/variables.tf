variable "kv_name" {
  description = "Name of the Key Vault (MUST BE GLOBALLY UNIQUE, max 24 chars, letters/numbers/hyphens)"
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

variable "tenant_id" {
  description = "Azure Active Directory Tenant ID"
  type        = string
}

variable "object_id" {
  description = "Object ID of the user executing the Terraform code"
  type        = string
}