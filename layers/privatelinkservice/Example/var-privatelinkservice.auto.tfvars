resource_group_name = "jumpstart-windows-vm-westus2"

private_link_services = {
  pls1 = {
    name                           = "jstartvm10142020pls" # "<private_link_service_name>"
    loadbalancer_name              = null                  #"jstartvmlb1"         # "<loadbalancer_name>"
    frontend_ip_config_name        = "jstartvmlbfrontend"  # "<lb_frontend_name>"
    subnet_name                    = "proxy"               # "<subnet_name>"
    vnet_name                      = null                  #"jstartvmssfirst"      # "<vnet_name>"
    networking_resource_group      = null
    private_ip_address             = null                  # "<private_ip_address>"
    private_ip_address_version     = "IPv4"                # "<private_ip_address_version>"
    visibility_subscription_ids    = null                  # <["00000000-0000-0000-0000-000000000000"]>
    auto_approval_subscription_ids = null                  # <["00000000-0000-0000-0000-000000000000"]>
    enable_proxy_protocol          = null
  }
}

pls_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
