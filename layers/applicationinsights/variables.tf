variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the Application Insights component."
}

variable "app_insights_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# -
# - Application Insights
# -
variable "application_insights" {
  type = map(object({
    name                                  = string
    application_type                      = string
    retention_in_days                     = number
    daily_data_cap_in_gb                  = number
    daily_data_cap_notifications_disabled = bool
    sampling_percentage                   = number
    disable_ip_masking                    = bool
  }))
  description = "Map containing Application Insights details"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
