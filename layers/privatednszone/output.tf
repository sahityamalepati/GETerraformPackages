# #############################################################################
# # OUTPUTS Private DNS Zone
# #############################################################################

output "dns_zone_ids" {
  value       = [for d in azurerm_private_dns_zone.this : d.id]
  description = "Prviate DNS Zone Id's"
}

output "dns_zone_ids_map" {
  value       = { for d in azurerm_private_dns_zone.this : d.name => d.id }
  description = "Map of Prviate DNS Zone Id's"
}

output "dns_zone_vnet_link_ids" {
  value       = [for d in azurerm_private_dns_zone_virtual_network_link.this : d.id]
  description = "Resource Id's of the Private DNS Zone Virtual Network Link"
}

output "dns_zone_vnet_link_ids_map" {
  value       = { for d in azurerm_private_dns_zone_virtual_network_link.this : d.name => d.id... }
  description = "Map of Resource Id's of the Private DNS Zone Virtual Network Link"
}
