variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Windows Virtual Machine should exist"
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {
    monitor_enable = true
  }
}

# -
# - Windows VM's
# -
variable "windows_vms" {
  type = map(object({
    name                                 = string
    computer_name                        = string
    vm_size                              = string
    zone                                 = string
    assign_identity                      = bool
    availability_set_key                 = string
    ppg_keys                             = string
    vm_nic_keys                          = list(string)
    source_image_reference_publisher     = string
    source_image_reference_offer         = string
    source_image_reference_sku           = string
    source_image_reference_version       = string
    os_disk_name                         = string
    storage_os_disk_caching              = string
    managed_disk_type                    = string
    disk_size_gb                         = number
    write_accelerator_enabled            = bool
    recovery_services_vault_name         = string
    recovery_services_vault_rgname       = string
    vm_backup_policy_name                = string
    use_existing_disk_encryption_set     = bool
    existing_disk_encryption_set_name    = string
    existing_disk_encryption_set_rg_name = string
    enable_cmk_disk_encryption           = bool
    customer_managed_key_name            = string
    disk_encryption_set_name             = string
    enable_automatic_updates             = bool
    custom_data_path                     = string
    custom_data_args                     = map(string)
  }))
  description = "Map containing Windows VM objects"
  default     = {}
}

variable "windows_vm_nics" {
  type = map(object({
    name                           = string
    subnet_name                    = string
    vnet_name                      = string
    networking_resource_group      = string
    lb_backend_pool_names          = list(string)
    lb_nat_rule_names              = list(string)
    application_security_groups = list(object({
      name                      = string
      resource_group            = string
    }))
    app_gateway_backend_pool_names = list(string)
    internal_dns_name_label        = string
    enable_ip_forwarding           = bool
    enable_accelerated_networking  = bool
    dns_servers                    = list(string)
    nic_ip_configurations = list(object({
      name      = string
      static_ip = string
    }))
  }))
  description = "Map containing Windows VM NIC objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "Specifies the name of the local administrator account"
}

# -
# - Availability Sets
# -
variable "availability_sets" {
  type = map(object({
    name                         = string
    platform_update_domain_count = number
    platform_fault_domain_count  = number
  }))
  description = "Map containing availability set configurations"
  default     = {}
}

# -
# - Diagnostics Extensions
# -
variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
  default     = null
}

variable "diagnostics_sa_rgname"{
  type        = string
  description = "The name of diagnostics storage account resource group."
  default     = null
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the existing Key Vault Name where you want to store VM SSH Private Key."
  default     = null
}

variable "key_vault_rgname" {
  type        = string
  description = "The name of key vault resource group."
  default     = null
}

variable "kv_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in KV resource?"
  default     = false
}

variable "self_role_assignment" {
  type        = bool
  description = "Grant VM MSI Reader Role in VM resource ?"
  default     = false
}

# -
# - Managed Disks
# -
variable "managed_data_disks" {
  type = map(object({
    disk_name                 = string
    vm_key                    = string
    lun                       = string
    storage_account_type      = string
    disk_size                 = number
    caching                   = string
    write_accelerator_enabled = bool
    create_option             = string
    os_type                   = string
    source_resource_id        = string
  }))
  description = "Map containing storage data disk configurations"
  default     = {}
}

############################
# State File
############################
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}

variable "ppg" {
    type = map (object ({
    name     = string
  } ))
}
