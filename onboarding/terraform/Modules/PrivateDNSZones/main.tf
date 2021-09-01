variable p_dns_zones {
  description = "A Map of DNS Zone Objects"
  type = map(object({
    p_dns_zone_name      = string
    p_dns_zone_rg_name   = string
    p_dns_zone_vnet_name = string
    p_dns_zone_vnet_id   = string
  }))
}

variable "module_features" {}

variable tags {
  default = {}
}

resource "azurerm_private_dns_zone" "p_dns_zones" {
  for_each            = var.module_features ? var.p_dns_zones : {}
  name                = each.value["p_dns_zone_name"]
  resource_group_name = each.value["p_dns_zone_rg_name"]
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "private_dns_vnet_links" {
  for_each              = var.module_features ? var.p_dns_zones : {}
  name                  = substr("l2_${each.value["p_dns_zone_vnet_name"]}", 0, 80)
  resource_group_name   = azurerm_private_dns_zone.p_dns_zones[each.key].resource_group_name
  private_dns_zone_name = each.value["p_dns_zone_name"]
  virtual_network_id    = each.value["p_dns_zone_vnet_id"]
}

output "private_dns_zone_names" {
  value      = { for dnsz in var.p_dns_zones : dnsz.p_dns_zone_vnet_name => dnsz.p_dns_zone_name... }
  depends_on = [azurerm_private_dns_zone_virtual_network_link.private_dns_vnet_links]
}
