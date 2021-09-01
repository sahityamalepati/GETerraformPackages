# #############################################################################
# # OUTPUTS Linux VM Extensions
# #############################################################################

output "linux_virtual_machine" {
  value = data.azurerm_virtual_machine.this
}
