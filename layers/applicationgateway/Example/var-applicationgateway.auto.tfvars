resource_group_name = "[__resoure_group_name__]"

key_vault_resource_group = "ADO-Base-Infrastructure"
key_vault_name           = "ADO-Base-Infrastructure"
ado_subscription_id      = "9e9d8a58-6c9b-4cdb-8a7b-6450e36a6f51"

application_gateways = {
  "appgw1" = {
    name                       = "jstartall11222020gw"
    zones                      = ["1", "2", "3"]
    enable_http2               = true
    webapp_firewall_policy_key = "waf1"
    sku = {
      name     = "WAF_v2"
      tier     = "WAF_v2"
      capacity = 2
    }
    gateway_ip_configurations = [{
      name                      = "gateway-ip-configuration"
      subnet_name               = "applicationgateway"
      vnet_name                 = null #"jstartvmsssecond"
      networking_resource_group = "[__networking_resoure_group_name__]"
    }]
    frontend_ports = [
      {
        name = "appgateway-feporthttps"
        port = 443
      },
      {
        name = "appgateway-feporthttp"
        port = 80
      }
    ]
    frontend_ip_configurations = [
      {
        name                      = "appgateway-feip"
        subnet_name               = "applicationgateway"
        vnet_name                 = null #"jstartvmsssecond"
        networking_resource_group = "[__networking_resoure_group_name__]"
        static_ip                 = null
        enable_public_ip          = true
        domain_name_label         = "[__appgw_public_ip_domain_name_label__]"
      }
    ]
    backend_address_pools = [
      {
        name         = "appgateway-beap"
        fqdns        = null
        ip_addresses = null
      }
    ]
    backend_http_settings = [
      {
        name                                = "https-tc-be-htst"
        path                                = "/"
        port                                = 8443
        protocol                            = "Https"
        cookie_based_affinity               = "Enabled"
        request_timeout                     = 20
        probe_name                          = "https-tc-prob"
        host_name                           = "techchannel.pilot.com"
        pick_host_name_from_backend_address = false
      },
      {
        name                                = "https-tcadmin-be-htst"
        path                                = "/"
        port                                = 8444
        protocol                            = "Https"
        cookie_based_affinity               = "Enabled"
        request_timeout                     = 20
        probe_name                          = "https-tcadmin-prob"
        host_name                           = "admin.techchannel.pilot.com"
        pick_host_name_from_backend_address = false
      },
      {
        name                                = "http-tc-be-htst"
        path                                = "/"
        port                                = 8080
        protocol                            = "Http"
        cookie_based_affinity               = "Enabled"
        request_timeout                     = 20
        probe_name                          = "http-tc-prob"
        host_name                           = "techchannel.pilot.com"
        pick_host_name_from_backend_address = false
      },
      {
        name                                = "http-tcadmin-be-htst"
        path                                = "/"
        port                                = 8081
        protocol                            = "Http"
        cookie_based_affinity               = "Enabled"
        request_timeout                     = 20
        probe_name                          = "http-tcadmin-prob"
        host_name                           = "admin.techchannel.pilot.com"
        pick_host_name_from_backend_address = false
      }
    ]
    http_listeners = [
      {
        name                           = "https-tc-lstn"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttps"
        protocol                       = "Https"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "techchannel.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      },
      {
        name                           = "https-tcadmin-lstn"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttps"
        protocol                       = "Https"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "admin.techchannel.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      },
      {
        name                           = "https-tc-lstn-redirect"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttps"
        protocol                       = "Https"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "techchanneldev.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      },
      {
        name                           = "https-tcadmin-lstn-redirect"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttps"
        protocol                       = "Https"
        ssl_certificate_name           = "appgwclientcert"
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "admin.techchanneldev.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      },
      {
        name                           = "http-tc-lstn"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttp"
        protocol                       = "Http"
        ssl_certificate_name           = null
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "techchannel.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      },
      {
        name                           = "http-tcadmin-lstn"
        frontend_ip_configuration_name = "appgateway-feip"
        frontend_port_name             = "appgateway-feporthttp"
        protocol                       = "Http"
        ssl_certificate_name           = null
        sni_required                   = false
        listener_type                  = "MultiSite"
        host_name                      = "admin.techchannel.pilot.com"
        host_names                     = null
        webapp_firewall_policy_key     = null
      }
    ]
    request_routing_rules = [
      {
        name                        = "https-tc-rqrt"
        rule_type                   = "PathBasedRouting"
        listener_name               = "https-tc-lstn"
        backend_address_pool_name   = null
        backend_http_settings_name  = null
        rewrite_rule_set_name       = null
        redirect_configuration_name = null
        url_path_map_name           = "urlpathbasedmaps"
      },
      {
        name                        = "https-tcadmin-rqrt"
        rule_type                   = "Basic"
        listener_name               = "https-tcadmin-lstn"
        backend_address_pool_name   = "appgateway-beap"
        backend_http_settings_name  = "https-tcadmin-be-htst"
        rewrite_rule_set_name       = "appgatewayrwrs1"
        redirect_configuration_name = null
        url_path_map_name           = null
      },
      {
        name                        = "http-tc-rqrt"
        rule_type                   = "Basic"
        listener_name               = "http-tc-lstn"
        backend_address_pool_name   = null
        backend_http_settings_name  = null
        redirect_configuration_name = "tc-rconfig"
        rewrite_rule_set_name       = null
        url_path_map_name           = null
      },
      {
        name                        = "http-tcadmin-rqrt"
        rule_type                   = "Basic"
        listener_name               = "http-tcadmin-lstn"
        backend_address_pool_name   = null
        backend_http_settings_name  = null
        rewrite_rule_set_name       = null
        redirect_configuration_name = "tcadmin-rconfig"
        url_path_map_name           = null
      }
    ]
    url_path_maps = [{
      name                                = "urlpathbasedmaps"
      default_backend_http_settings_name  = null
      default_backend_address_pool_name   = null
      default_redirect_configuration_name = "tc-rconfig"
      default_rewrite_rule_set_name       = "appgatewayrwrs1"
      path_rules = [{
        name                        = "mytheartrule"
        paths                       = ["/*"]
        backend_http_settings_name  = null
        backend_address_pool_name   = null
        redirect_configuration_name = "tc-rconfig"
        rewrite_rule_set_name       = "appgatewayrwrs1"
      }]
    }]
    probes = [
      {
        name                                      = "https-tc-prob"
        path                                      = "/"
        protocol                                  = "Https"
        host                                      = "techchannel.pilot.com"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      },
      {
        name                                      = "https-tcadmin-prob"
        path                                      = "/"
        protocol                                  = "Https"
        host                                      = "admin.techchannel.pilot.com"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      },
      {
        name                                      = "http-tc-prob"
        path                                      = "/"
        protocol                                  = "Http"
        host                                      = "techchannel.pilot.com"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      },
      {
        name                                      = "http-tcadmin-prob"
        path                                      = "/"
        protocol                                  = "Http"
        host                                      = "admin.techchannel.pilot.com"
        interval                                  = null
        timeout                                   = null
        unhealthy_threshold                       = null
        pick_host_name_from_backend_http_settings = false
      }
    ]
    redirect_configurations = [
      {
        name                 = "tc-rconfig"
        redirect_type        = "Permanent"
        target_listener_name = "https-tc-lstn-redirect"
        target_url           = null
        include_path         = true
        include_query_string = true
      },
      {
        name                 = "tcadmin-rconfig"
        redirect_type        = "Permanent"
        target_listener_name = "https-tcadmin-lstn-redirect"
        target_url           = null
        include_path         = true
        include_query_string = true
      }
    ]
    rewrite_rule_sets = [{
      name = "appgatewayrwrs1"
      rewrite_rules = [{
        name          = "appgatewayrwr1"
        rule_sequence = 100
        conditions = [{
          variable    = "http_req_Authorization"
          pattern     = "^Bearer"
          ignore_case = true
          negate      = false
        }]
        request_header_configurations = [{
          header_name  = "X-Forwarded-For"
          header_value = "var_add_x_forwarded_for_proxy"
        }]
        response_header_configurations = [{
          header_name  = "Strict-Transport-Security"
          header_value = "max-age=31536000"
        }]
      }]
    }]
    waf_configuration                       = null
    disabled_ssl_protocols                  = null
    trusted_root_certificate_names          = ["appgwclientcert"]
    ssl_certificate_names                   = ["appgwclientcert"]
    key_vault_with_private_endpoint_enabled = true
  }
}

waf_policies = {
  waf1 = {
    name = "example-wafpolicy"
    custom_rules = [{
      name      = "Rule1"
      priority  = 1
      rule_type = "MatchRule"
      action    = "Block"
      match_conditions = [{
        match_variables = [{
          variable_name = "RemoteAddr"
          selector      = null
        }]
        operator           = "IPMatch"
        negation_condition = false
        match_values       = ["192.168.1.0/24", "10.0.0.0/24"]
        transforms         = null
      }]
    }]
    policy_settings = {
      enabled = true
      mode    = "Prevention"
    }
    managed_rules = {
      exclusions = [{
        match_variable          = "RequestHeaderNames"
        selector                = "x-company-secret-header"
        selector_match_operator = "Equals"
      }]
      managed_rule_sets = [{
        type    = "OWASP"
        version = "3.1"
        rule_group_overrides = [{
          rule_group_name = "REQUEST-920-PROTOCOL-ENFORCEMENT"
          disabled_rules  = ["920300", "920440"]
        }]
      }]
    }
  }
}

app_gateway_additional_tags = {
  iac                   = "Terraform"
  env                   = "uat"
  automated_by          = ""
  trafficmanager_enable = true
}
