# #############################################################################
# # OUTPUTS Virtual Machine Scalesets
# #############################################################################

output "windows_vmss_id" {
  value = [for x in azurerm_windows_virtual_machine_scale_set.this : x.id]
}

output "windows_vmss_id_map" {
  value = { for x in azurerm_windows_virtual_machine_scale_set.this : x.name => x.id }
}

output "windows_vmss_principal_ids" {
  value = local.vmss_principal_ids
}

output "windows_vmss" {
  value = azurerm_windows_virtual_machine_scale_set.this
}
