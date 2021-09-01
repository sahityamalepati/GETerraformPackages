variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which the Linux Virtual Machine Scale Set should be exist"
  default     = null
}

variable "virtual_machine_scaleset_extensions" {
  type = map(object({
    virtual_machine_scaleset_name = string
    custom_scripts = list(object({
      name                 = string
      command_to_execute   = string
      script_path          = string
      script_args          = map(string)
      file_uris            = list(string)
      storage_account_name = string
      resource_group_name  = string
    }))
    diagnostics_storage_config_path = string
  }))
}

variable "diagnostics_sa_name" {
  type        = string
  description = "The name of diagnostics storage account"
  default     = null
}

variable "loganalytics_workspace_name" {
  type        = string
  description = "The name of existing log analytics workspace to be used for diagnostic logs"
  default     = null
}

variable "enable_log_analytics_extension" {
  type    = bool
  default = false
}

variable "enable_storage_extension" {
  type    = bool
  default = false
}

variable "enable_network_watcher_extension" {
  type    = bool
  default = false
}

variable "ado_subscription_id" {
  type        = string
  description = "Specifies the ado subscription id"
  default     = null
}

############################
# State File
############################ 
variable "ackey" {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
