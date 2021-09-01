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
# - Resource Group
# -
variable "load_balancers" {
  type = map(object({
    name = string
    frontend_ips = list(object({
      name        = string
      subnet_name = string
      static_ip   = string
    }))
    backend_pool_names = list(string)
    add_public_ip      = bool
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
    lb_port                   = string
    backend_port              = number
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
    name             = string
    lb_key           = string
    protocol         = string
    backend_pool_name      = string
    allocated_outbound_ports = number
    frontend_ip_configuration_names = list(string)
    
  }))
  description = "Map containing outbound nat rule parameters"
  default     = {
    rule1 = {
    name             = "azuredevops"
    lb_key           = "devopslb1"
    protocol         = "Tcp"
    backend_pool_name      = "devopslbbackend"
    allocated_outbound_ports = 10664
    frontend_ip_configuration_names = ["devopslbfrontend"]
  }
  }
}

variable "load_balancer_nat_rules" {
  type = map(object({
    name                    = string
    lb_key                  = string
    frontend_ip_name        = string
    lb_port                 = number
    backend_port            = number
    idle_timeout_in_minutes = number
  }))
  description = "Map containing load balancer nat rule parameters"
  default     = {}
}

variable "zones" {
  type        = list(string)
  description = "A list of Availability Zones which the Load Balancer's IP Addresses should be created in"
  default     = ["1"]
}

variable "subnet_ids" {
  type        = map(string)
  description = "A map of subnet id's"
}

variable "emptylist" {
  type    = list(string)
  default = ["null", "null"]
}