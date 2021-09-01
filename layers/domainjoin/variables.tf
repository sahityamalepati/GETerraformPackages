variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Key Vault"
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_rg_name" {
  type = string
}

variable "domain_join_extensions" {
  type = map(object({
    secret_name          = string
    virtual_machine_name = string
  }))
  description = "(optional) describe your variable"
}

# this is the default resource group variable used by azure rm backend
variable "key_vault_subscription_id" {
  type        = string
  description = "key vault subscription id"
  default     = ""
}