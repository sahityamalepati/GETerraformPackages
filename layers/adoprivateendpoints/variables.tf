variable "ado_pe_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - ADO Private Endpoints
# -
variable "ado_private_endpoints" {
  type = map(object({
    name          = string
    resource_name = string
    group_ids     = list(string)
    dns_zone_name = string
  }))
  description = "Map containing Private Endpoint and Private DNS Zone details"
  default     = {}
}

variable "ado_resource_group_name" {
  type        = string
  description = "Specifies the existing ado agent resource group name"
  default     = null
}

variable "ado_vnet_name" {
  type        = string
  description = "Specifies the existing ado agent virtual network name"
  default     = null
}

variable "ado_subnet_name" {
  type        = string
  description = "Specifies the existing ado agent subnet name"
  default     = null
}

variable "ado_subscription_id" {
  type        = string
  description = "Specifies the ado subscription id"
  default     = null
}

variable "create_dns_record" {
  type        = bool
  description = "set true if dns a record need to be created"
  default     = false
}


############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
