resource_group_name = "jstart-all-dev-11092020"
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

subnets = {
  subnet1 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = null #jstartvmssfirst
    name              = "loadbalancer"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    pe_enable         = false
    delegation        = []
  },
  subnet2 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = null #jstartvmssfirst
    name              = "proxy"
    address_prefixes  = ["10.0.2.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet3 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = null #jstartvmssfirst
    name              = "application"
    address_prefixes  = ["10.0.3.0/24"]
    pe_enable         = false
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    delegation        = []
  },
  subnet4 = {
    vnet_key          = "virtualnetwork2"
    vnet_name         = null #jstartvmsssecond
    name              = "applicationgateway"
    address_prefixes  = ["172.16.0.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet5 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = null #jstartvmssfirst
    name              = "AzureFirewallSubnet"
    address_prefixes  = ["10.0.4.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
  },
  subnet6 = {
    vnet_key          = "virtualnetwork1"
    vnet_name         = null #jstartvmssfirst
    name              = "azfunction"
    address_prefixes  = ["10.0.0.0/24"]
    pe_enable         = false
    service_endpoints = null
    delegation = [{
      name = "azfunctionnetworkdel"
      service_delegation = [{
        name    = "Microsoft.Web/serverFarms"
        actions = []
      }]
    }]
  }
}

net_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}