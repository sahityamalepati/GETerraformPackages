variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Windows Virtual Machine Scale Set should be exist"
}

variable "vmss_additional_tags" {
  type        = map(string)
  description = "Tags of the vmss in addition to the resource group tag"
  default = {
    monitor_enable = true
  }
}

# -
# - Virtual Machine Scaleset
# -
variable "virtual_machine_scalesets" {
  type = map(object({
    name                                   = string
    computer_name_prefix                   = string
    vm_size                                = string
    zones                                  = list(string)
    assign_identity                        = bool
    instances                              = number
    networking_resource_group              = string
    subnet_name                            = string
    vnet_name                              = string
    application_security_groups            = list(object({
      name                                 = string
      resource_group                       = string
    }))
    lb_backend_pool_names                  = list(string)
    lb_nat_pool_names                      = list(string)
    app_gateway_name                       = string
    lb_probe_name                          = string
    source_image_reference_publisher       = string
    source_image_reference_offer           = string
    source_image_reference_sku             = string
    source_image_reference_version         = string
    storage_os_disk_caching                = string
    managed_disk_type                      = string
    disk_size_gb                           = number
    write_accelerator_enabled              = bool
    upgrade_mode                           = string
    enable_automatic_os_upgrade            = bool
    enable_cmk_disk_encryption             = bool
    enable_accelerated_networking          = bool
    enable_ip_forwarding                   = bool
    enable_automatic_instance_repair       = bool
    automatic_instance_repair_grace_period = string
    enable_default_auto_scale_settings     = bool
    enable_automatic_updates               = bool
    ultra_ssd_enabled                      = bool
    custom_data_path                       = string
    custom_data_args                       = map(string)
    storage_profile_data_disks = list(object({
      lun                       = number
      caching                   = string
      disk_size_gb              = number
      managed_disk_type         = string
      write_accelerator_enabled = bool
    }))
    rolling_upgrade_policy = object({
      max_batch_instance_percent              = number
      max_unhealthy_instance_percent          = number
      max_unhealthy_upgraded_instance_percent = number
      pause_time_between_batches              = string
    })
  }))
  description = "Map containing Windows VM Scaleset objects"
  default     = {}
}

variable "custom_auto_scale_settings" {
  type = map(object({
    name              = string
    vmss_key          = string
    profile_name      = string
    default_instances = number
    minimum_instances = number
    maximum_instances = number
    rule = list(object({
      metric_name      = string
      time_grain       = string
      statistic        = string
      time_window      = string
      time_aggregation = string
      operator         = string
      threshold        = number
      direction        = string
      type             = string
      value            = string
      cooldown         = string
    }))
  }))
  description = "Map containing Windows VM Scaleset Auto Scale Settings objects"
  default     = {}
}

variable "administrator_user_name" {
  type        = string
  description = "The username of the local administrator on each Virtual Machine Scale Set instance"
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones in which the Virtual Machines in this Scale Set should be created in"
  default     = []
}

# Diagnostics Extensions
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
  description = "Specifies the existing Key Vault Name where you want to store VMSS SSH Private Key."
  default     = null
}

variable "key_vault_rgname" {
  type        = string
  description = "The name of key vault resource group."
  default     = null
}

variable "kv_role_assignment" {
  type        = bool
  description = "Grant VMSS MSI Reader Role in KV resource?"
  default     = false
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
