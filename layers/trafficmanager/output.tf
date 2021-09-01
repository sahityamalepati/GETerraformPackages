# #############################################################################
# # OUTPUTS Traffic Manager Profile and Endpoint
# #############################################################################

output "traffic_manager_profiles_map" {
  value = { for t in azurerm_traffic_manager_profile.this : t.name => t }
}

output "traffic_manager_endpoints" {
  value = { for t in azurerm_traffic_manager_endpoint.this : t.name => t }
}
