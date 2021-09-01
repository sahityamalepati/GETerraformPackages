variable "resource_group_name" {
  description = "(Required) resource group name of private dns zone."
  type        = string
}

variable "dns_zone_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - Private DNS Zone
# -
variable "private_dns_zones" {
  type = map(object({
    dns_zone_name = string
    vnet_links = list(object({
      zone_to_vnet_link_name    = string
      vnet_name                 = string
      networking_resource_group = string
      zone_to_vnet_link_exists  = bool
    }))
    zone_exists          = bool
    registration_enabled = bool
  }))
  description = "Map containing Private DNS Zone Objects"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
