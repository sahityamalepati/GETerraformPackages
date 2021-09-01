variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Security Group components."
}

variable "app_security_groups_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# -
# - Application Security Groups
# -
variable "application_security_groups" {
  type = map(object({
    name = string
  }))
  description = "Map containing Application Security Group details"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
