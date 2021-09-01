variable "enable_kv_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for Key Vault resource "
  default     = false
}

variable "enable_kv_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for Key Vault resource"
  default     = false
}

variable "kv_logs" {
  type        = list(string)
  description = "List of log categories for Key Vault Resource."
  default     = null
}

variable "kv_metrics" {
  type        = list(string)
  description = "List of metric categories for Key Vault Resource."
  default     = null
}

variable "enable_aks_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for AKS Cluster resource"
  default     = false
}

variable "enable_aks_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for AKS Cluster resource"
  default     = false
}

variable "aks_logs" {
  type        = list(string)
  description = "List of log categories for AKS Cluster Resource."
  default     = null
}

variable "aks_metrics" {
  type        = list(string)
  description = "List of metric categories for AKS Cluster Resource."
  default     = null
}

variable "enable_appgw_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for Application Gateway resource"
  default     = false
}

variable "enable_appgw_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for Application Gateway resource"
  default     = false
}

variable "appgw_logs" {
  type        = list(string)
  description = "List of log categories for Application Gateway Resource."
  default     = null
}

variable "appgw_metrics" {
  type        = list(string)
  description = "List of metric categories for Application Gateway Resource."
  default     = null
}

variable "enable_cosmosdb_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for CosmosDB resource"
  default     = false
}

variable "enable_cosmosdb_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for CosmosDB resource"
  default     = false
}

variable "cosmosdb_logs" {
  type        = list(string)
  description = "List of log categories for CosmosDB Resource."
  default     = null
}

variable "cosmosdb_metrics" {
  type        = list(string)
  description = "List of metric categories for CosmosDB Resource."
  default     = null
}

variable "enable_mysql_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for MySQL Server resource"
  default     = false
}

variable "enable_mysql_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for MySQL Server resource"
  default     = false
}

variable "mysql_logs" {
  type        = list(string)
  description = "List of log categories for MySQL Server Resource."
  default     = null
}

variable "mysql_metrics" {
  type        = list(string)
  description = "List of metric categories for MySQL Server Resource."
  default     = null
}

variable "enable_appservice_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for Azure App Service resource"
  default     = false
}

variable "enable_appservice_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for Azure App Service resource"
  default     = false
}

variable "appservice_logs" {
  type        = list(string)
  description = "List of log categories for Azure App Service Resource."
  default     = null
}

variable "appservice_metrics" {
  type        = list(string)
  description = "List of metric categories for Azure App Service Resource."
  default     = null
}

variable "enable_azsql_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for Azure SQL resource"
  default     = false
}

variable "enable_azsql_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for Azure SQL resource"
  default     = false
}

variable "azsql_logs" {
  type        = list(string)
  description = "List of log categories for Azure SQL Resource."
  default     = null
}

variable "azsql_metrics" {
  type        = list(string)
  description = "List of metric categories for Azure SQL Resource."
  default     = null
}

variable "enable_postgresql_logs_to_log_analytics" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to Log Analytics for Postgre SQL resource"
  default     = false
}

variable "enable_postgresql_logs_to_storage" {
  type        = bool
  description = "Boolean flag to specify whether the logs should be sent to the Storage Account for Postgre SQL resource"
  default     = false
}

variable "postgresql_logs" {
  type        = list(string)
  description = "List of log categories for Postgre SQL Resource."
  default     = null
}

variable "postgresql_metrics" {
  type        = list(string)
  description = "List of metric categories for Postgre SQL Resource."
  default     = null
}

variable "diagnostics_storage_account_name" {
  type        = string
  description = "Specifies the name of the Storage Account where Diagnostics Data should be sent"
  default     = null
}

variable "custom_diagnostic_settings" {
  type = map(object({
    name           = string       # The name of the diagnostic setting.
    resource_id    = string       # The ID of the resource.
    enabled        = bool         # Either `true` to enable diagnostic settings or `false` to disable it.
    retention_days = number       # The number of days to keep diagnostic logs
    logs           = list(string) # List of log categories.
    metrics        = list(string) # List of metric categories.
  }))
  description = "Map of custom diagnostic log settings for azure resources."
  default     = {}
}
