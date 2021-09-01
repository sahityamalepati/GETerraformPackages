locals {
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  vm_state_exists            = length(values(data.terraform_remote_state.windowsvirtualmachine.outputs)) == 0 ? false : true
}

data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_virtual_machine" "this" {
  for_each            = local.vm_state_exists == false ? var.custom_script_extensions : {}
  name                = each.value.virtual_machine_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

resource "azurerm_virtual_machine_extension" "this" {
  for_each                   = var.custom_script_extensions
  name                       = each.value.name
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    "commandToExecute" : each.value.command_to_execute
  })

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)
}

