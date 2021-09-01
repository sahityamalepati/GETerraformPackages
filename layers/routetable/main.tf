data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

locals {
  tags                       = merge(var.rt_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
}

# -
# - Route Table
# -
resource "azurerm_route_table" "this" {
  for_each                      = var.route_tables
  name                          = each.value["name"]
  location                      = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name           = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  disable_bgp_route_propagation = lookup(each.value, "disable_bgp_route_propagation", null)

  dynamic "route" {
    for_each = lookup(each.value, "routes", [])
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "azure_firewall_name ", null) != null && lookup(route.value, "next_hop_in_ip_address", null) == null ? lookup(data.terraform_remote_state.azurefirewall.outputs.firewall_ips_map, route.value.azure_firewall_name, null) : lookup(route.value, "next_hop_in_ip_address", null)
    }
  }

  tags = merge(local.tags, each.value.tags)
}

locals {
  subnet_route_table_associations = {
    for k, v in var.route_tables : k => v if(v.subnet_name != null)
  }
}

# Associates a Route Table with a Subnet within a Virtual Network
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = local.subnet_route_table_associations
  route_table_id = azurerm_route_table.this[each.key]["id"]
  subnet_id      = lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name)
}
