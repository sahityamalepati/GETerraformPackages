resource_group_name = "jstart-all-dev-02012022"
net_location        = null

virtual_networks = {}

vnet_peering = {}

subnets = {
  subnet1 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
    name              = "loadbalancer"
    address_prefixes  = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    pe_enable         = false
    delegation        = []
    nsg_name          = "nsg1"
    nsg_resourece_group = null
  },
  subnet2 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
    name              = "proxy"
    address_prefixes  = ["10.0.2.0/24"]
    pe_enable         = true
    service_endpoints = null
    delegation        = []
    nsg_name          = null
    nsg_resourece_group = null
  },
  subnet3 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
    name              = "application"
    address_prefixes  = ["10.0.3.0/24"]
    pe_enable         = false
    service_endpoints = ["Microsoft.Sql", "Microsoft.AzureCosmosDB"]
    delegation        = []
    nsg_name          = "nsg1"
    nsg_resourece_group = null
  },
  subnet4 = {
    vnet_key          = null
    vnet_name         = "jstartvmsssecond"
    name              = "applicationgateway"
    address_prefixes  = ["172.16.0.0/24"]
    pe_enable         = false #true
    service_endpoints = null
    delegation        = []
    nsg_name          = "nsg1"
    nsg_resourece_group = null
  },
  subnet5 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
    name              = "AzureFirewallSubnet"
    address_prefixes  = ["10.0.4.0/24"]
    pe_enable         = false #true
    service_endpoints = null
    delegation        = []
    nsg_name          = "nsg1"
  nsg_resourece_group = "jstart-all-dev-01082021"
  },
  subnet6 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
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
    nsg_name          = "nsg1"
    nsg_resourece_group = null
  },
  subnet7 = {
    vnet_key          = null
    vnet_name         = "jstartvmssfirst"
    name              = "NetAppSubnet"
    address_prefixes  = ["10.0.10.0/24"]
    pe_enable         = false
    service_endpoints = null
    delegation = [{
      name = "netappdel"
      service_delegation = [{
        name    = "Microsoft.Netapp/volumes"
        actions = []
      }]
    }]
    nsg_name            = null #"nsg1" no nsg for netapp subnet
    nsg_resourece_group = null
  }
}

net_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}