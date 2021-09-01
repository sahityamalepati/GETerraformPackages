# #############################################################################
# # OUTPUTS Application Gateway
# #############################################################################

output "application_gateway_ids" {
  value = [for x in azurerm_application_gateway.this : x.id]
}

output "application_gateway_ids_map" {
  value = { for x in azurerm_application_gateway.this : x.name => x.id }
}

output "frontend_ips_map" {
  value = { for x in azurerm_application_gateway.this : x.name => x.frontend_ip_configuration.0.id }
}

output "application_gateway_backend_pools_map" {
  value = {
    for x in azurerm_application_gateway.this :
    x.name => x.backend_address_pool.*.id
  }
}

locals {
  backend_address_pools = flatten([
    for k, v in var.application_gateways : [
      for backend_pool in azurerm_application_gateway.this[k].backend_address_pool.*.id : {
        name = split("/", backend_pool)[length(split("/", backend_pool)) - 1]
        id   = backend_pool
      }
    ]
  ])
}

output "application_gateway_backend_pool_ids_map" {
  value = { for x in local.backend_address_pools : x.name => x.id }
}

output "application_gateway_backend_pools" {
  value = {
    for x in var.application_gateways : x.name => [
      for y in x.backend_address_pools : y.name
    ] if x.backend_address_pools != null
  }
}