# #############################################################################
# # OUTPUTS ADO rivate Endpoint
# #############################################################################

output "private_endpoint_ids" {
  value       = [for pe in azurerm_private_endpoint.this : pe.id]
  description = "ADO Private Endpoint Id's"
}

output "private_ip_addresses" {
  value       = [for pe in azurerm_private_endpoint.this : pe.private_service_connection.*.private_ip_address]
  description = "ADO Private Endpoint IP Addresses"
}

output "private_ip_addresses_map" {
  value       = { for pe in azurerm_private_endpoint.this : pe.name => pe.private_service_connection.*.private_ip_address }
  description = "Map of ADO Private Endpoint IP Addresses"
}
