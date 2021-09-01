variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault"
}

variable "rsv_additional_tags" {
  type        = map(string)
  description = "Additional Recovery Services Vault resources tags, in addition to the resource group tags"
  default     = {}
}

# -
# - Recover Services Vault
# -
variable "recovery_services_vaults" {
  type = map(object({
    name                = string # (Required) Specifies the name of the Recovery Services Vault.
    sku                 = string # (Required) Sets the vault's SKU. Possible values include: Standard, RS0.
    soft_delete_enabled = bool   # (Optional) Is soft delete enable for this Vault? Defaults to true.
    policy_name         = string
    backup_settings = object({
      frequency = string # (Required) Sets the backup frequency. Must be either Daily orWeekly.
      time      = string # (Required) The time of day to perform the backup in 24hour format.
      weekdays  = string # (Optional) The days of the week to perform backups on and weekdays should be seperated by ','(comma).
    })
    retention_settings = object({
      daily   = number # (Required) The number of daily backups to keep. Must be between 1 and 9999
      weekly  = string # count:weekdays and weekdays should be seperated by ','(comma)
      monthly = string # count:weekdays:weeks and weekdays & weeks should be seperated by ','(comma)
      yearly  = string # count:weekdays:weeks:months and weekdays, weeks & months should be seperated by ','(comma)
    })
  }))
  description = "Map of recover services vaults properties"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
