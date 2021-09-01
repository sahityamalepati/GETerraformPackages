variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Gateway component."
}

variable "app_gateway_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

# -
# - Application Gateway
# -
variable "application_gateways" {
  type = map(object({
    name                       = string
    webapp_firewall_policy_key = string
    zones                      = list(string)
    enable_http2               = bool
    sku = object({
      name     = string
      tier     = string
      capacity = number
    })
    gateway_ip_configurations = list(object({
      name                      = string
      subnet_name               = string
      vnet_name                 = string
      networking_resource_group = string
    }))
    frontend_ports = list(object({
      name = string
      port = number
    }))
    frontend_ip_configurations = list(object({
      name                      = string
      subnet_name               = string
      vnet_name                 = string
      networking_resource_group = string
      static_ip                 = string
      enable_public_ip          = bool
      domain_name_label         = string
    }))
    backend_address_pools = list(object({
      name         = string
      fqdns        = list(string)
      ip_addresses = list(string)
    }))
    backend_http_settings = list(object({
      name                                = string
      cookie_based_affinity               = string
      path                                = string
      port                                = number
      request_timeout                     = number
      probe_name                          = string
      protocol                            = string
      host_name                           = string
      pick_host_name_from_backend_address = bool
    }))
    http_listeners = list(object({
      name                           = string
      frontend_ip_configuration_name = string
      frontend_port_name             = string
      ssl_certificate_name           = string
      protocol                       = string
      sni_required                   = bool
      listener_type                  = string       # MultiSite or Basic
      host_name                      = string       # Required if listener_type = MultiSite and host_names = null
      host_names                     = list(string) # Required if listener_type = MultiSite and host_name = null
      webapp_firewall_policy_key     = string       # The Key of the Map of Web Application Firewall Policies which should be used as a HTTP Listener.
    }))
    request_routing_rules = list(object({
      name                        = string
      rule_type                   = string
      listener_name               = string
      backend_address_pool_name   = string
      backend_http_settings_name  = string
      redirect_configuration_name = string
      url_path_map_name           = string
      rewrite_rule_set_name       = string
    }))
    url_path_maps = list(object({
      name                                = string
      default_backend_http_settings_name  = string
      default_backend_address_pool_name   = string
      default_redirect_configuration_name = string
      default_rewrite_rule_set_name       = string
      path_rules = list(object({
        name                        = string
        paths                       = list(string)
        backend_http_settings_name  = string
        backend_address_pool_name   = string
        redirect_configuration_name = string
        rewrite_rule_set_name       = string
      }))
    }))
    probes = list(object({
      name                                      = string
      path                                      = string
      interval                                  = number
      protocol                                  = string
      timeout                                   = number
      unhealthy_threshold                       = number
      host                                      = string
      pick_host_name_from_backend_http_settings = bool
    }))
    redirect_configurations = list(object({
      name                 = string
      redirect_type        = string
      target_listener_name = string
      target_url           = string
      include_path         = bool
      include_query_string = bool
    }))
    rewrite_rule_sets = list(object({
      name = string
      rewrite_rules = list(object({
        name          = string
        rule_sequence = number
        conditions = list(object({
          variable    = string
          pattern     = string
          ignore_case = bool
          negate      = bool
        }))
        request_header_configurations = list(object({
          header_name  = string
          header_value = string
        }))
        response_header_configurations = list(object({
          header_name  = string
          header_value = string
        }))
      }))
    }))
    autoscale_configuration = object({
      min_capacity = number
      max_capacity = number
    })
    disabled_ssl_protocols                  = list(string)
    trusted_root_certificate_names          = list(string)
    ssl_certificate_names                   = list(string)
    key_vault_with_private_endpoint_enabled = bool
  }))
  description = "Map containing Application Gateways details"
  default     = {}
}

variable "waf_policies" {
  type = map(object({
    name = string
    custom_rules = list(object({
      name      = string
      priority  = number
      rule_type = string
      action    = string
      match_conditions = list(object({
        match_variables = list(object({
          variable_name = string
          selector      = string
        }))
        operator           = string
        negation_condition = bool
        match_values       = list(string)
        transforms         = list(string)
      }))
    }))
    policy_settings = object({
      enabled = bool
      mode    = string
    })
    managed_rules = object({
      exclusions = list(object({
        match_variable          = string
        selector                = string
        selector_match_operator = string
      }))
      managed_rule_sets = list(object({
        type    = string
        version = string
        rule_group_overrides = list(object({
          rule_group_name = string
          disabled_rules  = list(string)
        }))
      }))
    })
  }))
  description = "Map containing Web Application Firewall details"
  default     = {}
}

variable "key_vault_resource_group" {
  type        = string
  description = "Specifies the Resource Group name where source Key Vault exists"
  default     = null
}

variable "key_vault_name" {
  type        = string
  description = "Specifies the Key Vault name where SSL Certificate exists"
  default     = null
}

variable "ado_subscription_id" {
  type        = string
  description = "Specifies the ado subscription id"
  default     = null
}

############################
# State File
############################
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
