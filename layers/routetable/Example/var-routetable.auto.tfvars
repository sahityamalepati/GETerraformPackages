resource_group_name = "jstart-appservice-dev-08122020"
route_tables = {
  rt1 = {
    name                          = "routetablesample"
    disable_bgp_route_propagation = false
    subnet_name                   = "appservice"
    tags                          = {}
    routes = [{
      name                   = "route1"
      address_prefix         = "10.1.0.0/16"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = null
      azure_firewall_name    = "firewallatt08182020"
    }]
  }
}