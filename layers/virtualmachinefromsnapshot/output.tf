# #############################################################################
# # OUTPUTS Linux VM
# #############################################################################

output "vm_resource_group_names" {
  value = [for x in azurerm_virtual_machine.vms : x.resource_group_name]
}

output "vm_names" {
  value = [for x in azurerm_virtual_machine.vms : x.name]
}

output "vm_ids" {
  value = [for x in azurerm_virtual_machine.vms : x.id]
}

output "vms" {
  value = azurerm_virtual_machine.vms
}

output "vm_id_map" {
  value = { for x in azurerm_virtual_machine.vms : x.name => x.id }
}

output "vm_tags_map" {
  value = { for x in azurerm_virtual_machine.vms : x.name => x.tags }
}

output "timestamp" {
  value = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}
