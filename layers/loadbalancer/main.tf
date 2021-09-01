data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

locals {
  tags                       = merge(var.lb_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true

  public_ips = {
    for k, v in var.load_balancers :
    k => v if lookup(v, "enable_public_ip", false) == true
  }

  frontend_ip_subnets_list = flatten([
    for lb_k, lb_v in var.load_balancers : [
      for frontend_ip in coalesce(lb_v.frontend_ips, []) : {
        key                       = format("%s_%s", lb_k, frontend_ip.name)
        subnet_name               = frontend_ip.subnet_name
        vnet_name                 = frontend_ip.vnet_name
        networking_resource_group = frontend_ip.networking_resource_group
      } if(frontend_ip.subnet_name != null && frontend_ip.vnet_name != null)
    ]
  ])
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? { for x in local.frontend_ip_subnets_list : x.key => x } : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

resource "azurerm_public_ip" "this" {
  for_each            = local.public_ips
  name                = each.value.public_ip_name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = local.tags
}

# -
# - Load Balancer
# -
resource "azurerm_lb" "this" {
  for_each            = var.load_balancers
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  sku                 = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? "Standard" : coalesce(each.value.sku, "Standard")

  dynamic "frontend_ip_configuration" {
    for_each = coalesce(lookup(each.value, "frontend_ips"), [])
    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? null : (local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, frontend_ip_configuration.value.subnet_name, null) : lookup(data.azurerm_subnet.this, "${each.key}_${frontend_ip_configuration.value.name}")["id"])
      private_ip_address_allocation = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? null : (lookup(frontend_ip_configuration.value, "static_ip", null) == null ? "dynamic" : "static")
      private_ip_address            = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? null : lookup(frontend_ip_configuration.value, "static_ip", null)
      public_ip_address_id          = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? lookup(azurerm_public_ip.this, each.key)["id"] : null
      zones                         = coalesce(lookup(each.value, "enable_public_ip"), false) == true ? null : lookup(frontend_ip_configuration.value, "zones", null)
    }
  }

  tags = local.tags

  depends_on = [azurerm_public_ip.this]
}

# -
# - Load Balancer Backend Address Pool
# -
locals {
  backend_pools = flatten([
    for lb_k, lb_v in var.load_balancers :
    [
      for backend_pool_name in coalesce(lb_v.backend_pool_names, []) :
      {
        lb_key = lb_k
        name   = backend_pool_name
      }
    ]
  ])
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each            = { for bp in local.backend_pools : format("%s_%s", bp.lb_key, bp.name) => bp }
  name                = each.value.name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id     = lookup(azurerm_lb.this, each.value.lb_key)["id"]
  depends_on          = [azurerm_lb.this]
}

# -
# - Load Balancer Probe
# -
resource "azurerm_lb_probe" "this" {
  for_each            = var.load_balancer_rules
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id     = lookup(azurerm_lb.this, each.value["lb_key"], null)["id"]
  port                = each.value["probe_port"]
  protocol            = lookup(each.value, "probe_protocol", null)
  request_path        = lookup(each.value, "probe_protocol", null) == "Tcp" ? null : lookup(each.value, "request_path", null)
  interval_in_seconds = lookup(each.value, "probe_interval", null)
  number_of_probes    = lookup(each.value, "probe_unhealthy_threshold", null)
  depends_on          = [azurerm_lb.this]
}

# -
# - Load Balancer Rule
# -
locals {
  backend_address_pool_map = {
    for bp in local.backend_pools : bp.name => format("%s_%s", bp.lb_key, bp.name)
  }
}

resource "azurerm_lb_rule" "this" {
  for_each                       = var.load_balancer_rules
  name                           = each.value["name"]
  resource_group_name            = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id                = lookup(azurerm_lb.this, each.value["lb_key"])["id"]
  protocol                       = coalesce(each.value["lb_protocol"], "Tcp")
  frontend_port                  = each.value["lb_port"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = each.value["frontend_ip_name"]
  backend_address_pool_id        = lookup(azurerm_lb_backend_address_pool.this, lookup(local.backend_address_pool_map, each.value["backend_pool_name"]))["id"]
  probe_id                       = lookup(azurerm_lb_probe.this, each.key, null) != null ? lookup(azurerm_lb_probe.this, each.key)["id"] : null
  load_distribution              = lookup(each.value, "load_distribution", null)
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", null)
  enable_floating_ip             = coalesce(lookup(each.value, "enable_floating_ip"), false)
  disable_outbound_snat          = coalesce(lookup(each.value, "disable_outbound_snat"), false)
  enable_tcp_reset               = coalesce(lookup(each.value, "enable_tcp_reset"), false)
  depends_on                     = [azurerm_lb.this, azurerm_lb_backend_address_pool.this, azurerm_lb_probe.this]
}
# -
# - Load Balancer outbound Rule
# -
resource "azurerm_lb_outbound_rule" "this" {
  for_each                 = var.lb_outbound_rules
  resource_group_name      = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id          = lookup(azurerm_lb.this, each.value["lb_key"])["id"]
  name                     = each.value["name"]
  protocol                 = each.value["protocol"]
  backend_address_pool_id  = lookup(azurerm_lb_backend_address_pool.this, lookup(local.backend_address_pool_map, each.value["backend_pool_name"]))["id"]
  allocated_outbound_ports = lookup(each.value, "allocated_outbound_ports", null)

  dynamic "frontend_ip_configuration" {
    for_each = lookup(each.value, "frontend_ip_configuration_names", [])
    content {
      name = frontend_ip_configuration.value
    }
  }
  depends_on = [azurerm_lb.this, azurerm_lb_backend_address_pool.this]
}

# -
# - Load Balancer NAT Rule
# -
locals {
  load_balancer_nat_rules_list = flatten([
    for nat_k, nat_v in var.load_balancer_nat_rules : [
      for key in coalesce(nat_v.lb_keys, []) : {
        key      = nat_k
        lb_key   = key
        nat_rule = nat_v
      }
    ]
  ])

  load_balancer_nat_rules = {
    for nat_rule in local.load_balancer_nat_rules_list :
    format("%s_%s", nat_rule.key, nat_rule.lb_key) => nat_rule
  }
}
resource "azurerm_lb_nat_rule" "this" {
  for_each                       = local.load_balancer_nat_rules
  name                           = each.value.nat_rule["name"]
  resource_group_name            = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id                = lookup(azurerm_lb.this, each.value["lb_key"])["id"]
  protocol                       = "Tcp"
  frontend_port                  = each.value.nat_rule["lb_port"]
  backend_port                   = each.value.nat_rule["backend_port"]
  frontend_ip_configuration_name = each.value.nat_rule["frontend_ip_name"]
  idle_timeout_in_minutes        = lookup(each.value.nat_rule, "idle_timeout_in_minutes", null)
  depends_on                     = [azurerm_lb.this]
}

# -
# - Load Balancer NAT Pool
# -
resource "azurerm_lb_nat_pool" "this" {
  for_each                       = var.load_balancer_nat_pools
  name                           = each.value["name"]
  resource_group_name            = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  loadbalancer_id                = lookup(azurerm_lb.this, each.value["lb_key"])["id"]
  protocol                       = "Tcp"
  frontend_port_start            = each.value["lb_port_start"]
  frontend_port_end              = each.value["lb_port_end"]
  backend_port                   = each.value["backend_port"]
  frontend_ip_configuration_name = each.value["frontend_ip_name"]
  depends_on                     = [azurerm_lb.this]
}
