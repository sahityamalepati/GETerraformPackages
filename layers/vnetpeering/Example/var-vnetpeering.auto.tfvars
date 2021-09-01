vnet_peering = {
  peer1 = {
    destination_vnet_name        = "jstartvmsecond"
    destination_vnet_rg          = "jumpstart-windows-vm-eastus2"
    source_vnet_name             = "jstartvmfirst"
    source_vnet_rg               = "jumpstart-windows-vm-eastus2"
    allow_forwarded_traffic      = true
    allow_virtual_network_access = true
    allow_gateway_transit        = false
    use_remote_gateways          = false
  }
}

destination_vnet_subscription_id = "9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51"
