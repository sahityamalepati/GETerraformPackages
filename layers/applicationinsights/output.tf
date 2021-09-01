# #############################################################################
# # OUTPUTS Application Insights
# #############################################################################

output "instrumentation_key_map" {
  value = { for x in azurerm_application_insights.this : x.name => x.instrumentation_key }
}

output "app_id_map" {
  value = { for x in azurerm_application_insights.this : x.name => x.app_id }
}