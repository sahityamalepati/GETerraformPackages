variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the App Services."
}


variable "appservice_slots_swap" {
  type = map(object({
   app_service_key = string
   app_service_slot_key = string 
  }))
  default = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
