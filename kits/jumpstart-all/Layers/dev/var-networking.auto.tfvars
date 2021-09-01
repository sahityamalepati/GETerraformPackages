resource_group_name = "jstart-all-dev-02012022"
net_location        = null

virtual_networks = {
  virtualnetwork1 = {
    name                 = "jstartvmssfirst"
    address_space        = ["10.0.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  },
  virtualnetwork2 = {
    name                 = "jstartvmsssecond"
    address_space        = ["172.16.0.0/16"]
    dns_servers          = null
    ddos_protection_plan = null
  }
}

vnet_peering = {}

subnets = {}

net_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}