data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_private_endpoint_connection" "this" {
  for_each            = local.privateendpoints_state_exists == false ? var.dns_a_records : {}
  name                = each.value.private_endpoint_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

locals {
  tags                          = merge(var.dns_records_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists    = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  privateendpoints_state_exists = length(values(data.terraform_remote_state.privateendpoints.outputs)) == 0 ? false : true
}

# -
# - DNS A Records
# -
resource "azurerm_private_dns_a_record" "this" {
  for_each            = var.dns_a_records
  name                = each.value["a_record_name"]
  zone_name           = each.value["dns_zone_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  ttl                 = coalesce(lookup(each.value, "ttl"), 3600)
  records             = each.value["private_endpoint_name"] != null ? (local.privateendpoints_state_exists == true ? flatten(lookup(data.terraform_remote_state.privateendpoints.outputs.private_ip_addresses_map, each.value["private_endpoint_name"], null)) : flatten(data.azurerm_private_endpoint_connection.this[each.key].custom_dns_configs.*.ip_addresses)) : lookup(each.value, "ip_addresses", null)
  tags                = local.tags
}

# -
# - DNS CNAME Records
# -
resource "azurerm_private_dns_cname_record" "this" {
  for_each            = var.dns_cname_records
  name                = each.value["cname_record_name"]
  zone_name           = each.value["dns_zone_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  ttl                 = coalesce(lookup(each.value, "ttl"), 3600)
  record              = each.value["record"]
  tags                = local.tags
}

# -
# - DNS SRV Records
# -
resource "azurerm_private_dns_srv_record" "this" {
  for_each            = var.dns_srv_records
  name                = each.value["srv_record_name"]
  zone_name           = each.value["dns_zone_name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  ttl                 = coalesce(lookup(each.value, "ttl"), 3600)

  dynamic "record" {
    for_each = coalesce(lookup(each.value, "records"), [])
    content {
      priority = record.value.priority
      weight   = record.value.weight
      port     = record.value.port
      target   = record.value.target
    }
  }

  tags = local.tags
}
