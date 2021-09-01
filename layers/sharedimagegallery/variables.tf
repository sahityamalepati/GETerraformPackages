variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Shared Image Gallery."
}

variable "sig_additional_tags" {
  type        = map(string)
  description = "Tags of the Shared Image Gallery in addition to the resource group tag."
  default     = {}
}

variable "shared_image_galleries" {
  type = map(object({
    name        = string
    description = string
  }))
  description = "Map of shared image galleries which needs to be created in a resource group"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
