variable "resource_group_name" {
  description = "name of the resource group"
}

variable "flow_logs" {
  type = map(object({
    nsg_name                 = string
    storage_account_name     = string
    network_watcher_name     = string
    network_watcher_rg_name  = string
    retention_days           = string
    enable_traffic_analytics = string
    interval_in_minutes      = number
  }))
  default = {}
}

variable "loganalytics_workspace_name" {
  type        = string
  description = "The name of attached log analytics workspace."
  default     = null
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
