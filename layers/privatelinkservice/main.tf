data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.private_link_services : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)

}

data "azurerm_lb" "this" {
  for_each            = local.loadbalancer_state_exists == false ? var.private_link_services : {}
  name                = each.value.loadbalancer_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

locals {
  tags                       = merge(var.pls_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  loadbalancer_state_exists  = length(values(data.terraform_remote_state.loadbalancer.outputs)) == 0 ? false : true

  frontend_ip_configurations = flatten([
    for lb in data.azurerm_lb.this : [
      for config in lb.frontend_ip_configuration : {
        name = config.name
        id   = config.id
      }
    ]
  ])
  frontend_ip_configurations_map = {
    for config in local.frontend_ip_configurations : config.name => config.id
  }
}

# -
# - Private Link Service
# -
resource "azurerm_private_link_service" "this" {
  for_each            = var.private_link_services
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  auto_approval_subscription_ids              = lookup(each.value, "auto_approval_subscription_ids", null)
  visibility_subscription_ids                 = lookup(each.value, "visibility_subscription_ids", null)
  load_balancer_frontend_ip_configuration_ids = local.loadbalancer_state_exists == true ? (length(lookup(data.terraform_remote_state.loadbalancer.outputs.frontend_ip_configurations_map, each.value.frontend_ip_config_name, [])) > 0 ? list(lookup(data.terraform_remote_state.loadbalancer.outputs.frontend_ip_configurations_map, each.value.frontend_ip_config_name)[0]) : null) : list(lookup(local.frontend_ip_configurations_map, each.value.frontend_ip_config_name))
  enable_proxy_protocol                       = coalesce(each.value.enable_proxy_protocol, false)

  nat_ip_configuration {
    name                       = "${each.value["name"]}_primary_pls_nat"
    private_ip_address         = lookup(each.value, "private_ip_address", null)
    private_ip_address_version = coalesce(lookup(each.value, "private_ip_address_version"), "IPv4")
    subnet_id                  = local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]
    primary                    = true
  }

  tags = local.tags
}
