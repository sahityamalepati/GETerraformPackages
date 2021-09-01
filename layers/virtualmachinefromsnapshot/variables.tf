variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Linux Virtual Machine should exist"
}

variable "vm_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default = {
    monitor_enable = true
  }
}

# -
# - Linux VM's
# -
variable "vms" {
  type = map(object({
    name                                 = string
    vm_size                              = string
    zone                                 = string
    availability_set_key                 = string
    ppg_keys                             = string
    vm_nic_keys                          = list(string)
    source_snapshot_id                   = string
    source_snapshot_os_type              = string
    os_disk_name                         = string
    storage_os_disk_caching              = string
    managed_disk_type                    = string
    disk_size_gb                         = number
    write_accelerator_enabled            = bool
    recovery_services_vault_name         = string
    vm_backup_policy_name                = string
    ultra_ssd_enabled                    = bool
  }))
  description = "Map containing Linux VM objects"
  default     = {}
}

variable "vm_nics" {
  type = map(object({
    name                           = string
    subnet_name                    = string
    vnet_name                      = string
    networking_resource_group      = string
    lb_backend_pool_names          = list(string)
    lb_nat_rule_names              = list(string)
    app_security_group_names       = list(string)
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
  description = "Map containing Linux VM NIC objects"
  default     = {}
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


#############################
# Proximity Placement Group
#############################
variable "ppg" {
    type = map (object ({
    name     = string
  } ))
}


############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
