# #############################################################################
# # OUTPUTS VNet Peering
# #############################################################################

output "vnet_peering_source_to_dest" {
  value = [for x in azurerm_virtual_network_peering.source_to_destination : x.id]
}

output "vnet_peering_dest_to_source" {
  value = [for x in azurerm_virtual_network_peering.destination_to_source : x.id]
}
