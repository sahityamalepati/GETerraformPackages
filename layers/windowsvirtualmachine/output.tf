
# #############################################################################
# # OUTPUTS Windows VM
# #############################################################################

output "windows_vm_resource_group_names" {
  value = [for x in azurerm_windows_virtual_machine.windows_vms : x.resource_group_name]
}

output "windows_vm_names" {
  value = [for x in azurerm_windows_virtual_machine.windows_vms : x.name]
}

output "windows_vm_ids" {
  value = [for x in azurerm_windows_virtual_machine.windows_vms : x.id]
}

output "vm_object" {
  value = azurerm_windows_virtual_machine.windows_vms
}

output "windows_vm_id_map" {
  value = { for x in azurerm_windows_virtual_machine.windows_vms : x.name => x.id }
}

output "windows_vm_tags_map" {
  value = { for x in azurerm_windows_virtual_machine.windows_vms : x.name => x.tags }
}

output "windows_vm_identity_map" {
  value = { for x in azurerm_windows_virtual_machine.windows_vms : x.name => x.identity.*.principal_id }
}
