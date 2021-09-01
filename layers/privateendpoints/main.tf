data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.private_endpoints : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

locals {
  tags                       = merge(var.pe_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
}

# -
# - Private Endpoint Connection
# -
data "azurerm_private_endpoint_connection" "this" {
  for_each            = var.private_endpoints
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  depends_on          = [azurerm_private_endpoint.this]
}

# -
# - Private Endpoint
# -
resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoints
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  subnet_id           = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]

  private_service_connection {
    name                           = "${each.value["name"]}-connection"
    private_connection_resource_id = lookup(var.resource_ids, each.value.resource_name, null) == null ? lookup(var.external_resource_ids, each.value.resource_name, null) : lookup(var.resource_ids, each.value.resource_name, null)
    is_manual_connection           = coalesce(lookup(each.value, "approval_required"), false)
    subresource_names              = lookup(each.value, "group_ids", null)
    request_message                = coalesce(lookup(each.value, "approval_required"), false) == true ? coalesce(lookup(each.value, "approval_message"), var.approval_message) : null
  }

  tags = local.tags
}
