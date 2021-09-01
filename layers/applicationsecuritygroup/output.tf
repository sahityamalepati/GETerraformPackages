# #############################################################################
# # OUTPUTS Application Security Groups
# #############################################################################

output "app_security_group_ids" {
  value = [for x in azurerm_application_security_group.this : x.id]
}

output "app_security_group_ids_map" {
  value = { for x in azurerm_application_security_group.this : x.name => x.id }
}
