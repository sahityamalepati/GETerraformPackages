resource_group_name = "jstart-all-dev-02012022"

load_balancers = {
  loadbalancer1 = {
    name = "jstartalllb1"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "jstartalllbfrontend"
        subnet_name               = "loadbalancer"
        vnet_name                 = "jstartvmssfirst" #null
        networking_resource_group = "jstart-all-dev-02012022"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones                     = null
      },
      {
        name                      = "jstartalllbfrontend1"
        subnet_name               = "loadbalancer"
        vnet_name                 = "jstartvmssfirst" #null
        networking_resource_group = "jstart-all-dev-02012022"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP
        zones                     = null
      }
    ]
    backend_pool_names = ["jstartalllbbackend", "jstartalllbbackend1"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null
  },
  loadbalancer2 = {
    name = "jstartalllb2"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "jstartalllbfrontend"
        subnet_name               = "loadbalancer"
        vnet_name                 = "jstartvmssfirst" #null
        networking_resource_group = "jstart-all-dev-02012022"
        static_ip                 = null # "10.0.1.4" #(Optional) Set null to get dynamic IP 
        zones                     = null
      }
    ]
    backend_pool_names = ["jstartalllbbackend2"]
    enable_public_ip   = false # set this to true to if you want to create public load balancer
    public_ip_name     = null
  },
  loadbalancer3 = {
    name = "jstartalllbpublic1"
    sku  = "Standard"
    frontend_ips = [
      {
        name                      = "jstartalllbfrontendpublic"
        subnet_name               = null
        vnet_name                 = null
        networking_resource_group = "jstart-all-dev-02012022"
        static_ip                 = null
        zones                     = null
      }
    ]
    backend_pool_names = ["jstartalllbbackendpublic"]
    enable_public_ip   = true
    public_ip_name     = "jstartalllbpublicip1"
  }
}

load_balancer_rules = {
  loadbalancerrules1 = {
    name                      = "jstartalllbrule"
    lb_key                    = "loadbalancer1"
    frontend_ip_name          = "jstartalllbfrontend"
    backend_pool_name         = "jstartalllbbackend"
    lb_protocol               = null
    lb_port                   = "22"
    probe_port                = "22"
    backend_port              = "22"
    enable_floating_ip        = null
    disable_outbound_snat     = null
    enable_tcp_reset          = null
    probe_protocol            = "Tcp"
    request_path              = "/"
    probe_interval            = 15
    probe_unhealthy_threshold = 2
    load_distribution         = "SourceIPProtocol"
    idle_timeout_in_minutes   = 5
  }
}

load_balancer_nat_pools = {}

lb_outbound_rules = {
  rule1 = {
    name                            = "outboundrule"
    lb_key                          = "loadbalancer3"
    protocol                        = "Tcp"
    backend_pool_name               = "jstartalllbbackendpublic"
    allocated_outbound_ports        = null
    frontend_ip_configuration_names = ["jstartalllbfrontendpublic"]
  }
}

load_balancer_nat_rules = {
  loadbalancernatrules1 = {
    name                    = "jstartalllbnatrule"
    lb_keys                 = ["loadbalancer1"]
    frontend_ip_name        = "jstartalllbfrontend"
    lb_port                 = 80
    backend_port            = 22
    idle_timeout_in_minutes = 5
  }
}

lb_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}