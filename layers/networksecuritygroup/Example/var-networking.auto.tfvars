resource_group_name = "jstart-vm-dev-111420"

network_security_groups = {
  nsg1 = {
    name                      = "nsg1"
    tags                      = { log_workspace = "jstartvmdev111420law" }
    subnet_name               = "loadbalancer"
    vnet_name                 = null
    networking_resource_group = null
    security_rules = [
      {
        name                                         = "nsg"
        description                                  = "NSG"
        priority                                     = 101
        direction                                    = "Outbound"
        access                                       = "Allow"
        protocol                                     = "Tcp"
        source_port_range                            = "*"
        source_port_ranges                           = null
        destination_port_range                       = "*"
        destination_port_ranges                      = null
        source_address_prefix                        = "*"
        source_address_prefixes                      = null
        destination_address_prefix                   = "*"
        destination_address_prefixes                 = null
        source_application_security_group_names      = null # ["asg-src"]
        destination_application_security_group_names = null # ["asg-dest"]
      }
    ]
  }
}

nsg_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}