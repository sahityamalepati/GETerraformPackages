resource "azurerm_virtual_network" "vnets" {
  for_each            = var.virtual_networks
  name                = "${var.common_vars.name_prefix}-${each.value["name"]}-vnet"
  location            = var.common_vars.region 
  resource_group_name = var.rg_name
  address_space       = each.value["address_space"]
  dns_servers         = lookup(each.value, "dns_servers", null)
}

# - Subnet

resource "azurerm_subnet" "subnets" {
  for_each            = var.subnets
  name                = "${var.common_vars.name_prefix}-${each.value["name"]}-snet"
  resource_group_name = "${var.common_vars.name_prefix}-${each.value["vnet_key"]}-rg"
  address_prefixes    = list(each.value["address_prefix"])

  virtual_network_name                           = "${var.common_vars.name_prefix}-${each.value["vnet_key"]}-vnet"
  service_endpoints                              = lookup(each.value, "pe_enable", false) == false ? lookup(each.value, "service_endpoints", []) : null
  enforce_private_link_endpoint_network_policies = lookup(each.value, "pe_enable", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "pe_enable", false)

  depends_on = [azurerm_virtual_network.vnets]
}
