variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the resource group in which to create the Azure Network Base Infrastructure Resources."
}

variable "netapp_account" {
  type        = string
  description = "NetApp Account"
  default     = null
}

variable "netapp_location" {
  type        = string
  description = "NetApp resources location if different than the resource group's location."
  default     = null
}
variable "existing_netapp_account"{
  type        = string
  description = "integrating with the existing netapp resources"
  default     = null
}

variable "existing_netapp_account_rg_name"{
  type        = string
  description = "integrating with the existing netapp resources"
  default     = null
}
variable "netapp_additional_tags" {
  type        = map(string)
  description = "Additional NetApp resources tags, in addition to the resource group tags."
  default     = {}
}

variable "iterator" {
    description = "This iterator forces the null_resource to run again when changed"
    default = 1
}

# -
# - NetApp Pools Name
# -
variable "netapp_pools" {
  description = "NetApp Pools"
  type = map(object({
    pool_name     = string
    service_level = string
    size_in_tb    = number
  }))
  default = {}
}

variable "netapp_volumes" {
  type = map(object({
    pool_key            = string
    name                = string
    volume_path         = string
    service_level       = string
    subnet_name         = string
    vnet_name                      = string
    networking_resource_group      = string
    storage_quota_in_gb = number
    protocols           = list(string)
//    prevent_destroy = bool
    export_policy_rules = list(object({
      allowed_clients = list(string)
      protocols_enabled = list(string)
      unix_read_write = bool
    }))
  }))
  default = {}
}

//variable "netapp_snapshots" {
//  type = map(object({
//    name       = string
//    pool_key   = string
//    volume_key = string
//  }))
//}

variable "netapp_snapshot_policies" {
  type= map(object({
    snapshotPolicyName = string
    hourlySnapshots = number
    dailySnapshots = number
    monthlySnapshots = number
    monthlydays = number
    monthlyhour = number
    monthlyminute = number
    weeklySnapshots = number
    enabled = bool
    delpolicy = number
  }))
}

############################
# State File
############################
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
