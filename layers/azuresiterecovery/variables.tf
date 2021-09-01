variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Recovery Services Vault"
  default     = ""
}

variable "rsv_additional_tags" {
  type        = map(string)
  description = "Additional Recovery Services Vault resources tags, in addition to the resource group tags"
  default     = {}
}

variable "recovery_services_vaults" {
  type = map(object({
    name                                                  = string # (Required) Specifies the name of the Recovery Services Vault.
    sku                                                   = string # (Required) Sets the vault's SKU. Possible values include: Standard, RS0.
    soft_delete_enabled                                   = bool   # (Optional) Is soft delete enable for this Vault? Defaults to true.
    primary_region                                        = string
#    recovery_cache_rg                                     = string
    replication_policies                = list(object({
        asr_replication_policy_name     = string
        recovery_point_retention_in_minutes = number
        application_consistent_snapshot_frequency_in_minutes  = number
    }))

    network_mapping                = list(object({
        name                = string
        primary_vnet_id     = string
        secondary_vnet_id   = string
    }))

    protected_items                           = list(object({
        source_vm_id                          = string
        source_osdisk_id                      = string
        source_datadisk_ids                   = list(string)
        source_nic_id                         = string
        target_resource_group_name            = string
        target_subnet_name                    = string
        asr_replication_policy_name           = string
        cmk_disk_encryption_enabled           = bool
        target_disk_encryption_set_name       = string
        target_disk_encryption_set_rg_name    = string
        target_ppg_name                       = string 
    }))
  }))
  description = "Map of recover services vaults properties"
  default     = {}
}