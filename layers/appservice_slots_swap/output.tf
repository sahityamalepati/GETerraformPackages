# #############################################################################
# # OUTPUTS 
# #############################################################################

output "app_service_name" {
  value = [ for x in azurerm_app_service_active_slot.this : x.app_service_name ]
}