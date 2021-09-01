# #############################################################################
# # OUTPUTS Role Definition and Role Assignment
# #############################################################################

output "rold_definition_ids_map" {
  value       = { for rd in azurerm_role_definition.this : rd.name => rd.id }
  description = "The Map of the Role Definition IDs."
}

output "role_assignment_ids_map" {
  value       = { for ra in azurerm_role_assignment.this : ra.name => ra.id }
  description = "The Map of the Role Assignment IDs."
}
