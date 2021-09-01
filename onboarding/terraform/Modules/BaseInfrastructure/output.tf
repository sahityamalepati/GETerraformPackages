# #############################################################################
# # OUTPUTS
# #############################################################################

output base_rg_name {
  value = azurerm_virtual_network.vnets["vnet1"].resource_group_name
}

output base_rg_region {
  value = var.common_vars.region
}

output base_vnet_names {
  value = [for v in azurerm_virtual_network.vnets : v.name]
}

output base_vnet_ids {
  value = [for v in azurerm_virtual_network.vnets : v.id]
}

output base_subnet_names {
  value = [for s in azurerm_subnet.subnets : s.name]
}

output base_subnet_ids {
  value = { for s in azurerm_subnet.subnets : s.name => s.id }
}
