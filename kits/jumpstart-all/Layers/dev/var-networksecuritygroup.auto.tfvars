resource_group_name = "jstart-all-dev-02012022"

network_security_groups = {
  nsg1 = {
    name                      = "nsg1"
    tags                      = { log_workspace = "jstartall01082021law" }
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
        source_address_prefix                        = null
        source_address_prefixes                      = null
        destination_address_prefix                   = null
        destination_address_prefixes                 = null
        source_application_security_group_names      = ["asg-src-1"]
        destination_application_security_group_names = ["asg-dest-1"]
      }
    ]
  }
}

nsg_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}