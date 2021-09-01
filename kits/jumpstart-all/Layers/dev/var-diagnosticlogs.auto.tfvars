enable_kv_logs_to_log_analytics = true
enable_kv_logs_to_storage       = true
kv_logs                         = null # List of log categories
kv_metrics                      = null # List of metric categories

enable_aks_logs_to_log_analytics = true
enable_aks_logs_to_storage       = true
aks_logs                         = null # List of log categories
aks_metrics                      = null # List of metric categories

enable_appgw_logs_to_log_analytics = true
enable_appgw_logs_to_storage       = true
appgw_logs                         = null # List of log categories
appgw_metrics                      = null # List of metric categories

enable_cosmosdb_logs_to_log_analytics = true
enable_cosmosdb_logs_to_storage       = true
cosmosdb_logs                         = null # List of log categories
cosmosdb_metrics                      = null # List of metric categories

enable_mysql_logs_to_log_analytics = true
enable_mysql_logs_to_storage       = true
mysql_logs                         = null # List of log categories
mysql_metrics                      = null # List of metric categories

enable_appservice_logs_to_log_analytics = false
enable_appservice_logs_to_storage       = false
appservice_logs                         = null # List of log categories
appservice_metrics                      = null # List of metric categories

enable_azsql_logs_to_log_analytics = true
enable_azsql_logs_to_storage       = true
azsql_logs                         = null # List of log categories
azsql_metrics                      = null # List of metric categories

enable_postgresql_logs_to_log_analytics = true
enable_postgresql_logs_to_storage       = true
postgresql_logs                         = null # List of log categories
postgresql_metrics                      = null # List of metric categories

diagnostics_storage_account_name = "jstartall02012022sa"

# custom_diagnostic_settings = {
#   log1 = {
#     name           = "customkvlog"
#     resource_id    = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jumpstart-windows-vm-westus2/providers/Microsoft.KeyVault/vaults/jstartvmdev101420kv"
#     enabled        = true
#     retention_days = 0
#     logs           = null
#     metrics        = null
#   }
# }
