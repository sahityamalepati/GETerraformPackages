# #############################################################################
# # OUTPUTS Private Endpoint
# #############################################################################

output "private_endpoint_ids" {
  value       = [for pe in azurerm_private_endpoint.this : pe.id]
  description = "Private Endpoint Id's"
}

output "private_ip_addresses" {
  value       = [for pe in azurerm_private_endpoint.this : pe.custom_dns_configs.*.ip_addresses]
  description = "Private Endpoint IP Addresses"
}

output "private_ip_addresses_map" {
  value       = { for pe in azurerm_private_endpoint.this : pe.name => pe.custom_dns_configs.*.ip_addresses }
  description = "Map of Private Endpoint IP Addresses"
}

