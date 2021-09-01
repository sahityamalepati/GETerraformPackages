variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Azure Automation account"
}
variable "automation_account_name" {
  type        = string
  description = "The name of the Azure Automation account"
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analyitcs Workspace to link to the Azure Automation account"
}

variable "azure_automation_account_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

variable "enable_update_management" {
  type        = bool
  description = "Whether to enable update management"
  default     = true
}

variable "enable_change_tracking" {
  type        = bool
  description = "Whether to enable change tracking"
  default     = true
}

variable "location" {
  type        = string
  description = "The location of the Automation Account and Log Analytics Solutions"
  default     = null
}

variable log_analytics_resource_group_name {
  type = string
  description = "The Resource Group name of the Log Analytics Workspace"
}
############################
# State File
############################
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
