variable "resource_group_name" {
  type        = string
  description = "The name of the Resource Group in which to create the Load Balancer"
}

variable "lb_additional_tags" {
  type        = map(string)
  description = "Tags of the load balancer in addition to the resource group tag."
  default     = {}
}

# -
# - Load Balancer
# -
variable "load_balancers" {
  type = map(object({
    name = string
    sku  = string
    frontend_ips = list(object({
      name                      = string
      subnet_name               = string
      vnet_name                 = string
      networking_resource_group = string
      static_ip                 = string
      zones                     = list(string)
    }))
    backend_pool_names = list(string)
    enable_public_ip   = bool
    public_ip_name     = string
  }))
  description = "Map containing load balancers"
  default     = {}
}

variable "load_balancer_rules" {
  type = map(object({
    name                      = string
    lb_key                    = string
    frontend_ip_name          = string
    backend_pool_name         = string
    lb_protocol               = string
    lb_port                   = string
    backend_port              = number
    enable_floating_ip        = bool
    disable_outbound_snat     = bool
    enable_tcp_reset          = bool
    probe_port                = number
    probe_protocol            = string
    request_path              = string
    probe_interval            = number
    probe_unhealthy_threshold = number
    load_distribution         = string
    idle_timeout_in_minutes   = number
  }))
  description = "Map containing load balancer rule and probe parameters"
  default     = {}
}

variable "load_balancer_nat_pools" {
  type = map(object({
    name             = string
    lb_key           = string
    frontend_ip_name = string
    lb_port_start    = number
    lb_port_end      = number
    backend_port     = number
  }))
  description = "Map containing load balancer nat pool parameters"
  default     = {}
}

variable "lb_outbound_rules" {
  type = map(object({
    name                            = string
    lb_key                          = string
    protocol                        = string
    backend_pool_name               = string
    allocated_outbound_ports        = number
    frontend_ip_configuration_names = list(string)

  }))
  description = "Map containing outbound nat rule parameters"
  default     = {}
}

variable "load_balancer_nat_rules" {
  type = map(object({
    name                    = string
    lb_keys                 = list(string)
    frontend_ip_name        = string
    lb_port                 = number
    backend_port            = number
    idle_timeout_in_minutes = number
  }))
  description = "Map containing load balancer nat rule parameters"
  default     = {}
}

variable "emptylist" {
  type    = list(string)
  default = ["null", "null"]
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
