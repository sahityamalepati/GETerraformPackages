# #############################################################################
# # OUTPUTS KV Diagnostic Logs
# #############################################################################

output "kv_log_analytics_diagnostic_logs" {
  description = "Log analytics diagnostic logs"
  value       = azurerm_monitor_diagnostic_setting.kv_log_analytics
}

output "kv_storage_diagnostic_logs" {
  description = "Storage diagnostic logs"
  value       = azurerm_monitor_diagnostic_setting.kv_storage
}