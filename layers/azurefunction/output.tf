# #############################################################################
# # OUTPUTS App Service Plans and Azure Function App
# #############################################################################

output "function_apps" {
  value       = { for k, b in azurerm_function_app.this : k => b }
  description = "Map output of the Azure Function Apps"
}

output "app_service_plans" {
  value       = { for k, b in azurerm_app_service_plan.this : k => b }
  description = "Map output of the App Service Plans"
}
