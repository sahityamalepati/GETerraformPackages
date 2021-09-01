# #############################################################################
# # OUTPUTS Private Link Service
# #############################################################################

output "pls_ids" {
  value       = [for p in azurerm_private_link_service.this : p.id]
  description = "Private Link Service Id"
}

output "pls_dns_names" {
  value       = [for p in azurerm_private_link_service.this : p.alias]
  description = "A globally unique DNS Name for your Private Link Service. You can use this alias to request a connection to your Private Link Service."
}

output "private_link_service_map_ids" {
  value = { for p in azurerm_private_link_service.this : p.name => p.id }
}
