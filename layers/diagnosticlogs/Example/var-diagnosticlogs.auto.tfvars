enable_kv_logs_to_log_analytics = true
enable_kv_logs_to_storage       = true
kv_logs                         = [] # List of log categories
kv_metrics                      = [] # List of metric categories

enable_aks_logs_to_log_analytics = true
enable_aks_logs_to_storage       = true
aks_logs                         = [] # List of log categories
aks_metrics                      = [] # List of metric categories

enable_appgw_logs_to_log_analytics = true
enable_appgw_logs_to_storage       = true
appgw_logs                         = [] # List of log categories
appgw_metrics                      = [] # List of metric categories

enable_cosmosdb_logs_to_log_analytics = true
enable_cosmosdb_logs_to_storage       = true
cosmosdb_logs                         = [] # List of log categories
cosmosdb_metrics                      = [] # List of metric categories

enable_mysql_logs_to_log_analytics = true
enable_mysql_logs_to_storage       = true
mysql_logs                         = [] # List of log categories
mysql_metrics                      = [] # List of metric categories

enable_appservice_logs_to_log_analytics = true
enable_appservice_logs_to_storage       = true
appservice_logs                         = [] # List of log categories
appservice_metrics                      = [] # List of metric categories

enable_azsql_logs_to_log_analytics = true
enable_azsql_logs_to_storage       = true
azsql_logs                         = [] # List of log categories
azsql_metrics                      = [] # List of metric categories

diagnostics_storage_account_name = "jstartvmdev111420sa"

custom_diagnostic_settings = {
  log1 = {
    name           = "customkvlog"
    resource_id    = "/subscriptions/9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51/resourceGroups/jumpstart-windows-vm-westus2/providers/Microsoft.KeyVault/vaults/jstartvmdev101420kv"
    enabled        = true
    retention_days = 0
    logs           = null
    metrics        = null
  }
}
