variable "subnet_rt_association" {
  type = list(object({
        vnet_name           = string
        subnet_name         = string
        vnet_rg             = string
        routetable_name     = string
        routetable_rg       = string
    }))
}