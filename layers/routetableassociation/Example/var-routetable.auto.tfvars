subnet_rt_association = [
    {
        vnet_name           = "277-gr-vnet"
        subnet_name         = "sn-bastion-dev"
        vnet_rg             = "cs-connectedVNET-277"
        routetable_name     = "rt-Private"
        routetable_rg       = "cs-connectedVNET"
    },
    {
        vnet_name           = "277-gr-vnet"
        subnet_name         = "sn-bastion-stage"
        vnet_rg             = "cs-connectedVNET-277"
        routetable_name     = "rt-Private"
        routetable_rg       = "cs-connectedVNET"
    }
]
