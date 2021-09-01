
data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

//data "azurerm_subnet" "this" {
//  for_each             = local.networking_state_exists == false ? local.subnet_network_security_group_associations : {}
//  name                 = each.value.subnet_name
//  virtual_network_name = each.value.vnet_name
//  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
//}

data "azurerm_application_security_group" "src" {
  for_each            = local.asg_state_exists == false ? { for asg in local.source_asg_names : asg.key => asg.name } : {}
  name                = each.value
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_application_security_group" "dest" {
  for_each            = local.asg_state_exists == false ? { for asg in local.destination_asg_names : asg.key => asg.name } : {}
  name                = each.value
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

locals {
  tags                       = merge(var.nsg_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
//  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  asg_state_exists           = length(values(data.terraform_remote_state.applicationsecuritygroup.outputs)) == 0 ? false : true

  source_asg_names = flatten([
    for k, v in var.network_security_groups : [
      for rule in coalesce(v.security_rules, []) : [
        for asg in coalesce(rule.source_application_security_group_names, []) : {
          key  = format("%s_%s_%s", k, rule.name, asg)
          name = asg
        }
      ]
    ]
  ])

  destination_asg_names = flatten([
    for k, v in var.network_security_groups : [
      for rule in coalesce(v.security_rules, []) : [
        for asg in coalesce(rule.destination_application_security_group_names, []) : {
          key  = format("%s_%s_%s", k, rule.name, asg)
          name = asg
        }
      ]
    ]
  ])
}

# -
# - Network Security Group
# -
resource "azurerm_network_security_group" "this" {
  for_each            = var.network_security_groups
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  dynamic "security_rule" {
    for_each = lookup(each.value, "security_rules", [])
    content {
      name                                       = security_rule.value["name"]
      description                                = lookup(security_rule.value, "description", null)
      protocol                                   = coalesce(security_rule.value["protocol"], "Tcp")
      direction                                  = security_rule.value["direction"]
      access                                     = coalesce(security_rule.value["access"], "Allow")
      priority                                   = security_rule.value["priority"]
      source_address_prefix                      = lookup(security_rule.value, "source_address_prefix", null)
      source_address_prefixes                    = lookup(security_rule.value, "source_address_prefixes", null)
      destination_address_prefix                 = lookup(security_rule.value, "destination_address_prefix", null)
      destination_address_prefixes               = lookup(security_rule.value, "destination_address_prefixes", null)
      source_port_range                          = lookup(security_rule.value, "source_port_range", null)
      source_port_ranges                         = lookup(security_rule.value, "source_port_ranges", null)
      destination_port_range                     = lookup(security_rule.value, "destination_port_range", null)
      destination_port_ranges                    = lookup(security_rule.value, "destination_port_ranges", null)
      source_application_security_group_ids      = lookup(security_rule.value, "source_application_security_group_names", null) != null ? [for asg_name in security_rule.value.source_application_security_group_names : (local.asg_state_exists == true ? lookup(data.terraform_remote_state.applicationsecuritygroup.outputs.app_security_group_ids_map, asg_name, null) : lookup(data.azurerm_application_security_group.src, "${each.key}_${security_rule.value.name}_${asg_name}")["id"])] : null
      destination_application_security_group_ids = lookup(security_rule.value, "destination_application_security_group_names", null) != null ? [for asg_name in security_rule.value.destination_application_security_group_names : (local.asg_state_exists == true ? lookup(data.terraform_remote_state.applicationsecuritygroup.outputs.app_security_group_ids_map, asg_name, null) : lookup(data.azurerm_application_security_group.dest, "${each.key}_${security_rule.value.name}_${asg_name}")["id"])] : null
    }
  }

  tags = merge(local.tags, coalesce(each.value.tags, {}))
}

//locals {
//  subnet_network_security_group_associations = {
//    for k, v in var.network_security_groups : k => v if(v.subnet_name != null)
//  }
//}

# Associates a Network Security Group with a Subnet within a Virtual Network
//resource "azurerm_subnet_network_security_group_association" "this" {
//  for_each                  = local.subnet_network_security_group_associations
//  network_security_group_id = azurerm_network_security_group.this[each.key]["id"]
//  subnet_id                 = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]
//}
