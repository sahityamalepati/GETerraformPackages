locals {
  tags = merge(var.ado_pe_additional_tags, data.azurerm_resource_group.this.0.tags)
}

# -	
# - ADO Private Endpoints
# -	
data "azurerm_resource_group" "this" {
  provider = azurerm.ado
  count    = (length(values(var.ado_private_endpoints)) > 0) ? 1 : 0
  name     = var.ado_resource_group_name
}

data "azurerm_subnet" "this" {
  provider             = azurerm.ado
  count                = (length(values(var.ado_private_endpoints)) > 0) ? 1 : 0
  name                 = var.ado_subnet_name
  virtual_network_name = var.ado_vnet_name
  resource_group_name  = data.azurerm_resource_group.this.0.name
}

resource "azurerm_private_endpoint" "this" {
  provider            = azurerm.ado
  for_each            = var.ado_private_endpoints
  name                = each.value["name"]
  location            = data.azurerm_resource_group.this.0.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  subnet_id           = data.azurerm_subnet.this.0.id

  private_service_connection {
    name                           = "${each.value["name"]}-connection"
    private_connection_resource_id = lookup(var.resource_ids, each.value.resource_name, null)
    is_manual_connection           = false
    subresource_names              = lookup(each.value, "group_ids", null)
    request_message                = null
  }

  lifecycle {
    ignore_changes = [
      private_service_connection[0].private_connection_resource_id
    ]
  }

  tags = local.tags
}

resource "azurerm_private_dns_a_record" "this" {
  provider            = azurerm.ado
  for_each            = var.create_dns_record ? var.ado_private_endpoints : {}
  name                = each.value["resource_name"]
  zone_name           = each.value["dns_zone_name"] # DNS Zone created in Agent	
  resource_group_name = data.azurerm_resource_group.this.0.name
  ttl                 = "300"
  records             = [azurerm_private_endpoint.this[each.key].private_service_connection[0].private_ip_address]
}
