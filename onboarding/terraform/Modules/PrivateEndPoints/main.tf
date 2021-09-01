variable "private_endpoints" {
  description = "Map containing private endpoints"
}

variable tags {
  default = {}
}
variable "module_features" {}

resource "azurerm_private_endpoint" "private_endpoints" {
  for_each            = var.module_features ? var.private_endpoints : {}
  name                = each.value.name
  location            = each.value.rg_region
  resource_group_name = each.value.rg_name
  subnet_id           = each.value.subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${each.value.name}-connection"
    private_connection_resource_id = each.value.resource_id
    is_manual_connection           = each.value.is_manual_connection
    subresource_names              = each.value.group_ids
    request_message                = each.value.is_manual_connection == true ? each.value.approval_message : null
  }
  
}


output private_ip_address {
  value = { for pe in azurerm_private_endpoint.private_endpoints : pe.name => pe.private_service_connection[0].private_ip_address }
}

output pe_name {
  value = [ for pe in azurerm_private_endpoint.private_endpoints : pe.name ]
}

output private_ip_custom_dns_configs {
  value = { for pe in azurerm_private_endpoint.private_endpoints : pe.name => pe.custom_dns_configs }
}