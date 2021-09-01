variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Traffic Manager resource"
}

variable "traffic_manager_additional_tags" {
  type        = map(string)
  description = "Tags of the Traffic Manager in addition to the resource group tag."
  default     = {}
}

# -
# - Traffic Manager Profile
# -
variable "traffic_manager_profiles" {
  type = map(object({
    name                         = string
    routing_method               = string
    profile_status               = string
    relative_domain_name         = string
    ttl                          = number
    protocol                     = string
    port                         = number
    path                         = string
    interval_in_seconds          = number
    timeout_in_seconds           = number
    tolerated_number_of_failures = number
    expected_status_code_ranges  = list(string)
    custom_headers = list(object({
      name  = string
      value = string
    }))
  }))
  description = "Map of traffic manager profiles which needs to be created in a resource group"
  default     = {}
}

# -
# - Traffic Manager Profile
# -
variable "traffic_manager_endpoints" {
  type = map(object({
    name                          = string
    profile_key                   = string
    profile_status                = string
    type                          = string
    target                        = string
    target_resource_endpoint_name = string
    weight                        = number
    priority                       = string
    endpoint_location             = string
    custom_headers = list(object({
      name  = string
      value = string
    }))
  }))
  description = "Map of traffic manager endpoints which needs to be created in a resource group"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
