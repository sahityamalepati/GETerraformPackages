#############################################################################
# OUTPUTS Load Balancer
#############################################################################

locals {
  frontend_ip_configurations = flatten([
    for lb in azurerm_lb.this : [
      for config in lb.frontend_ip_configuration : {
        name = config.name
        id   = config.id
      }
    ]
  ])
}

output "pri_lb_names" {
  value = [for x in azurerm_lb.this : x.name]
}

output "pri_lb_private_ip_address" {
  value = concat(
    [for x in azurerm_lb.this : x.private_ip_address],
    var.emptylist
  )
}

output "pri_lb_frontend_ip_configurations" {
  value = [for x in azurerm_lb.this : x.frontend_ip_configuration]
}

output "frontend_ip_configurations_map" {
  value = { for config in local.frontend_ip_configurations : config.name => config.id... }
}

output "pri_lb_backend_ids" {
  value = concat(
    [for x in azurerm_lb_backend_address_pool.this : x.id],
    var.emptylist
  )
}

output "pri_lb_backend_map_ids" {
  value = {
    for x in azurerm_lb_backend_address_pool.this : x.name => x.id
  }
}

output "pri_lb_rule_ids" {
  value = [for x in azurerm_lb_rule.this : x.id]
}

output "pri_lb_probe_ids" {
  value = [for x in azurerm_lb_probe.this : x.id]
}

output "pri_lb_probe_map_ids" {
  value = {
    for x in azurerm_lb_probe.this : x.name => x.id
  }
}

output "pri_lb_natrule_map_ids" {
  value = {
    for x in azurerm_lb_nat_rule.this : x.name => x.id
  }
}

output "pri_lb_natpool_map_ids" {
  value = {
    for x in azurerm_lb_nat_pool.this : x.name => x.id
  }
}
