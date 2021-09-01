variable "resource_group_name" {
  type        = string
  description = "Specifies the name of the Resource Group in which the Virtual Machine should exist"
  default     = null
}

variable "custom_script_extensions" {
  type = map(object({
    name                 = string
    virtual_machine_name = string
    command_to_execute   = string
  }))
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
