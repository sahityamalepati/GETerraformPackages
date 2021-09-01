data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#
#Swapping the app service slots
#
resource "azurerm_app_service_active_slot" "this" {
  for_each              = var.appservice_slots_swap
  resource_group_name   = data.azurerm_resource_group.this.name
  app_service_name      = lookup(data.terraform_remote_state.appservice.outputs.app_service_map, each.value["app_service_key"], null)
  app_service_slot_name = lookup(data.terraform_remote_state.appservice.outputs.app_service_slot_map, each.value["app_service_slot_key"], null)
  }
