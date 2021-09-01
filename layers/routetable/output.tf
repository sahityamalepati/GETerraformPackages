# #############################################################################
# # OUTPUTS RTs
# #############################################################################

output "route_table_ids" {
  value = [for x in azurerm_route_table.this : x.id]
}

output "rt_ids_map" {
  value = { for x in azurerm_route_table.this : x.name => x.id }
}