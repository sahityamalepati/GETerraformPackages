# #############################################################################
# # OUTPUTS Virtual Machine Scalesets
# #############################################################################

output "vmss_id" {
  value = [for x in azurerm_linux_virtual_machine_scale_set.this : x.id]
}

output "vmss_id_map" {
  value = { for x in azurerm_linux_virtual_machine_scale_set.this : x.name => x.id }
}

output "vmss_principal_ids" {
  value = local.vmss_principal_ids
}

output "vmss" {
  value = azurerm_linux_virtual_machine_scale_set.this
}

output "asg_ids"{
  value = data.azurerm_application_security_group.vmss_with_asg
}