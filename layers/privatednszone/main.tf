data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  for_each            = local.networking_state_exists == false ? local.zone_to_vnet_links : {}
  name                = each.value.vnet_name
  resource_group_name = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

locals {
  tags                       = merge(var.dns_zone_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true

  private_dns_zones = {
    for dz_k, dz_v in var.private_dns_zones :
    dz_k => dz_v if(coalesce(dz_v.zone_exists, false) == false && dz_v.dns_zone_name != null)
  }

  zone_to_vnet_links_distinct = distinct(flatten([
    for dz_k, dz_v in var.private_dns_zones : [
      for vnet in coalesce(dz_v.vnet_links, []) : {
        dns_zone_key              = dz_k
        dns_zone_name             = dz_v.dns_zone_name
        zone_to_vnet_link_name    = vnet.zone_to_vnet_link_name
        vnet_name                 = vnet.vnet_name
        networking_resource_group = vnet.networking_resource_group
        registration_enabled      = dz_v.registration_enabled
      } if(coalesce(vnet.zone_to_vnet_link_exists, false) == false && vnet.vnet_name != null)
    ] if(dz_v.zone_exists == false && dz_v.dns_zone_name != null)
  ]))

  zone_to_vnet_links = {
    for vnet_link in local.zone_to_vnet_links_distinct :
    "${vnet_link.dns_zone_key}_${vnet_link.zone_to_vnet_link_name}" => vnet_link
  }
}

# -
# - Private DNS Zone
# -
resource "azurerm_private_dns_zone" "this" {
  for_each            = local.private_dns_zones
  name                = each.value["dns_zone_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  tags                = local.tags
}

# -
# - Private DNS Zone to VNet Link
# -
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = local.zone_to_vnet_links
  name                  = substr(coalesce(each.value.zone_to_vnet_link_name, "${each.value["dns_zone_name"]}-${each.value["vnet_name"]}-link"), 0, 80)
  resource_group_name   = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  private_dns_zone_name = azurerm_private_dns_zone.this[each.value.dns_zone_key].name
  virtual_network_id    = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_vnet_ids, each.value.vnet_name) : lookup(data.azurerm_virtual_network.this, "${each.value.dns_zone_key}_${each.value.zone_to_vnet_link_name}")["id"]
  registration_enabled  = coalesce(each.value.registration_enabled, true)
  tags                  = local.tags
  depends_on            = [azurerm_private_dns_zone.this]
}
