output rg_name {
  value       =  [for r in azurerm_resource_group.rg : r.name]
  description = "Azure Resource Group Name"
}

# output rg_region {
#   description = "Azure Resource Gorup Region"
#   value       = azurerm_resource_group.rg.location
# }
