
data "azurerm_resource_group" "this" {
  count = 1
  name  = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  for_each            = local.existing_vnets
  name                = each.value
  resource_group_name = data.azurerm_resource_group.this.0.name
}

data "azurerm_network_security_group" "this" {
  for_each             = local.nsg_state_exists == false ? local.subnet_network_security_group_associations : {}
  name                 = each.value.nsg_name
  resource_group_name  = each.value.nsg_resourece_group != null ? each.value.nsg_resourece_group : data.azurerm_resource_group.this.0.name
}

locals {
  subnet_network_security_group_associations = {
    for k, v in var.subnets : k => v if(v.nsg_name != null)
  }
}

# Associates a Network Security Group with a Subnet within a Virtual Network
resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = local.subnet_network_security_group_associations
  network_security_group_id = local.nsg_state_exists  == true ? lookup(data.terraform_remote_state.networksecuritygroup.outputs.nsg_id_map, each.value.nsg_name) : lookup(data.azurerm_network_security_group.this, each.key)["id"]
  subnet_id = lookup(azurerm_subnet.this, each.key)["id"]
}

locals {
  location                   = var.net_location == null ? data.azurerm_resource_group.this.0.location : var.net_location
  tags                       = merge(var.net_additional_tags, data.azurerm_resource_group.this.0.tags)
  # resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  existing_vnets = {
    for subnet_k, subnet_v in var.subnets :
    subnet_k => subnet_v.vnet_name if(subnet_v.vnet_key == null && subnet_v.vnet_name != null)
  }

  nsg_state_exists    = length(values(data.terraform_remote_state.networksecuritygroup.outputs)) == 0 ? false : true
}
# -
# - Virtual Network
# -
resource "azurerm_virtual_network" "this" {
  for_each            = var.virtual_networks
  name                = each.value["name"]
  location            = local.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)

  dynamic "ddos_protection_plan" {
    for_each = lookup(each.value, "ddos_protection_plan", null) != null ? list(lookup(each.value, "ddos_protection_plan")) : []
    content {
      id     = lookup(ddos_protection_plan.value, "id", null)
      enable = coalesce(lookup(ddos_protection_plan.value, "enable"), false)
    }
  }

  tags = local.tags
}

# -
# - VNet Peering
# -
data "azurerm_virtual_network" "destination" {
  for_each            = var.vnet_peering
  name                = each.value["destination_vnet_name"]
  resource_group_name = each.value["destination_vnet_rg"]
  depends_on          = [azurerm_virtual_network.this]
}

locals {
  remote_vnet_id_map = {
    for k, v in data.azurerm_virtual_network.destination :
    v.name => v.id
  }
}

resource "azurerm_virtual_network_peering" "source_to_destination" {
  for_each                     = var.vnet_peering
  name                         = "${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}-to-${each.value["destination_vnet_name"]}"
  remote_virtual_network_id    = lookup(local.remote_vnet_id_map, each.value["destination_vnet_name"], null)
  resource_group_name          = data.azurerm_resource_group.this.0.name
  virtual_network_name         = lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]
  allow_forwarded_traffic      = coalesce(lookup(each.value, "allow_forwarded_traffic"), true)
  allow_virtual_network_access = coalesce(lookup(each.value, "allow_virtual_network_access"), true)
  allow_gateway_transit        = coalesce(lookup(each.value, "allow_gateway_transit"), false)
  use_remote_gateways          = coalesce(lookup(each.value, "use_remote_gateways"), false)
  depends_on                   = [azurerm_virtual_network.this]

  lifecycle {
    ignore_changes = [remote_virtual_network_id]
  }
}

resource "azurerm_virtual_network_peering" "destination_to_source" {
  for_each                     = var.vnet_peering
  name                         = "${each.value["destination_vnet_name"]}-to-${lookup(var.virtual_networks, each.value["vnet_key"], null)["name"]}"
  remote_virtual_network_id    = lookup(azurerm_virtual_network.this, each.value["vnet_key"], null)["id"]
  resource_group_name          = each.value["destination_vnet_rg"]
  virtual_network_name         = each.value["destination_vnet_name"]
  allow_forwarded_traffic      = coalesce(lookup(each.value, "allow_forwarded_traffic"), true)
  allow_virtual_network_access = coalesce(lookup(each.value, "allow_virtual_network_access"), true)
  allow_gateway_transit        = coalesce(lookup(each.value, "allow_gateway_transit"), false)
  use_remote_gateways          = coalesce(lookup(each.value, "use_remote_gateways"), false)
  depends_on                   = [azurerm_virtual_network.this]
}

# -
# - Subnet
# -
resource "azurerm_subnet" "this" {
  for_each                                       = var.subnets
  name                                           = each.value["name"]
  resource_group_name                            = data.azurerm_resource_group.this.0.name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = coalesce(lookup(each.value, "pe_enable"), false) == false ? lookup(each.value, "service_endpoints", null) : null
  enforce_private_link_endpoint_network_policies = coalesce(lookup(each.value, "pe_enable"), false)
  enforce_private_link_service_network_policies  = coalesce(lookup(each.value, "pe_enable"), false)
  virtual_network_name                           = each.value.vnet_key != null ? lookup(var.virtual_networks, each.value["vnet_key"])["name"] : data.azurerm_virtual_network.this[each.key].name

  dynamic "delegation" {
    for_each = coalesce(lookup(each.value, "delegation"), [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = coalesce(lookup(delegation.value, "service_delegation"), [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}
