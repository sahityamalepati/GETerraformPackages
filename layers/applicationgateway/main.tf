data "azurerm_resource_group" "this" {
  count = 1
  name  = var.resource_group_name
}

locals {
  tags = merge(var.app_gateway_additional_tags, data.azurerm_resource_group.this.0.tags)

  public_ip_list = flatten([
    for appgw_k, appgw_v in var.application_gateways :
    [
      for frontend_ip in appgw_v.frontend_ip_configurations :
      {
        key               = format("%s_%s", appgw_k, frontend_ip.name)
        name              = frontend_ip.name
        domain_name_label = frontend_ip.domain_name_label
      } if lookup(frontend_ip, "enable_public_ip", false) == true
    ]
  ])

  public_ips = {
    for public_ip in local.public_ip_list : public_ip.key => public_ip
  }

  default_sku = {
    name     = "WAF_v2"
    tier     = "WAF_v2"
    capacity = 2
  }

  default_waf_configuration = {
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.1"
    enabled          = true
  }

  trusted_root_certs_names = flatten([
    for k, v in var.application_gateways : [
      for certificate_name in v.trusted_root_certificate_names : {
        key              = format("%s_%s", k, certificate_name)
        certificate_name = certificate_name
      }
    ] if lookup(v, "trusted_root_certificate_names", null) != null
  ])

  ssl_certs_names = flatten([
    for k, v in var.application_gateways : [
      for certificate_name in v.ssl_certificate_names : {
        key              = format("%s_%s", k, certificate_name)
        certificate_name = certificate_name
      }
    ] if lookup(v, "ssl_certificate_names", null) != null
  ])

  frontend_ip_subnet_names = flatten([
    for appgw_k, appgw_v in var.application_gateways : [
      for frontend_ip in coalesce(appgw_v.frontend_ip_configurations, []) : {
        key                       = format("%s_%s", appgw_k, frontend_ip.name)
        subnet_name               = frontend_ip.subnet_name
        vnet_name                 = frontend_ip.vnet_name
        networking_resource_group = frontend_ip.networking_resource_group
      } if(frontend_ip.subnet_name != null && frontend_ip.vnet_name != null)
    ]
  ])

  gateway_ip_subnet_names = flatten([
    for appgw_k, appgw_v in var.application_gateways : [
      for gateway_ip in coalesce(appgw_v.gateway_ip_configurations, []) : {
        key                       = format("%s_%s", appgw_k, gateway_ip.name)
        subnet_name               = gateway_ip.subnet_name
        vnet_name                 = gateway_ip.vnet_name
        networking_resource_group = gateway_ip.networking_resource_group
      } if(gateway_ip.subnet_name != null && gateway_ip.vnet_name != null)
    ]
  ])
}

data "azurerm_subnet" "frontend_ip_subnet" {
  for_each             = { for x in local.frontend_ip_subnet_names : x.key => x }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : data.azurerm_resource_group.this.0.name
}

data "azurerm_subnet" "gateway_ip_subnet" {
  for_each             = { for x in local.gateway_ip_subnet_names : x.key => x }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : data.azurerm_resource_group.this.0.name
}

data "azurerm_key_vault" "this" {
  provider            = azurerm.ado
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resource_group
}

data "azurerm_key_vault_secret" "this" {
  provider = azurerm.ado
  for_each = {
    for cert in local.trusted_root_certs_names : cert.key => cert.certificate_name
  }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.this.id
}

data "azurerm_key_vault_secret" "ssl" {
  provider = azurerm.ado
  for_each = {
    for cert in local.ssl_certs_names : cert.key => cert.certificate_name
  }
  name         = each.value
  key_vault_id = data.azurerm_key_vault.this.id
}

resource "azurerm_user_assigned_identity" "this" {
  for_each            = var.application_gateways
  resource_group_name = data.azurerm_resource_group.this.0.name
  location            = data.azurerm_resource_group.this.0.location
  name                = each.value.name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

# -
# - Application Gateway Public IP
# -
resource "azurerm_public_ip" "this" {
  for_each            = local.public_ips
  name                = each.value.name
  location            = data.azurerm_resource_group.this.0.location
  resource_group_name = data.azurerm_resource_group.this.0.name
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = lookup(each.value, "domain_name_label", null)
  tags                = local.tags
}

# -
# - Application Gateway
# -
resource "azurerm_application_gateway" "this" {
  for_each            = var.application_gateways
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.0.name
  location            = data.azurerm_resource_group.this.0.location
  zones               = lookup(each.value, "zones", null)
  enable_http2        = coalesce(each.value.enable_http2, false)

  dynamic "sku" {
    for_each = lookup(each.value, "sku", null) == null ? [local.default_sku] : [merge(local.default_sku, each.value.sku)]
    content {
      name     = sku.value.name
      tier     = sku.value.tier
      capacity = sku.value.capacity
    }
  }

  dynamic "gateway_ip_configuration" {
    for_each = coalesce(lookup(each.value, "gateway_ip_configurations"), [])
    content {
      name      = gateway_ip_configuration.value.name
      subnet_id = lookup(data.azurerm_subnet.gateway_ip_subnet, "${each.key}_${gateway_ip_configuration.value.name}")["id"]
    }
  }

  dynamic "frontend_port" {
    for_each = coalesce(lookup(each.value, "frontend_ports"), [])
    content {
      name = frontend_port.value.name
      port = coalesce(frontend_port.value.port, 443)
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = coalesce(lookup(each.value, "frontend_ip_configurations"), [])
    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = coalesce(lookup(frontend_ip_configuration.value, "enable_public_ip"), false) == true ? null : lookup(data.azurerm_subnet.frontend_ip_subnet, "${each.key}_${frontend_ip_configuration.value.name}")["id"]
      private_ip_address_allocation = coalesce(lookup(frontend_ip_configuration.value, "enable_public_ip"), false) == true ? null : (frontend_ip_configuration.value.static_ip == null ? "dynamic" : "static")
      private_ip_address            = coalesce(lookup(frontend_ip_configuration.value, "enable_public_ip"), false) == true ? null : frontend_ip_configuration.value.static_ip
      public_ip_address_id          = coalesce(lookup(frontend_ip_configuration.value, "enable_public_ip"), false) == true ? lookup(azurerm_public_ip.this, "${each.key}_${frontend_ip_configuration.value.name}", null)["id"] : null
    }
  }

  dynamic "backend_address_pool" {
    for_each = coalesce(lookup(each.value, "backend_address_pools"), [])
    content {
      name         = backend_address_pool.value.name
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = coalesce(lookup(each.value, "backend_http_settings"), [])
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = coalesce(backend_http_settings.value.cookie_based_affinity, "Disabled")
      path                                = backend_http_settings.value.path
      port                                = coalesce(backend_http_settings.value.port, 443)
      protocol                            = coalesce(backend_http_settings.value.protocol, "Https")
      request_timeout                     = coalesce(backend_http_settings.value.request_timeout, 20)
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)
      host_name                           = coalesce(backend_http_settings.value.pick_host_name_from_backend_address, false) == false ? lookup(backend_http_settings.value, "host_name", null) : null
      pick_host_name_from_backend_address = coalesce(backend_http_settings.value.pick_host_name_from_backend_address, false)
      trusted_root_certificate_names      = coalesce(backend_http_settings.value.protocol, "Https") == "Https" ? lookup(each.value, "trusted_root_certificate_names", null) : null
    }
  }

  dynamic "trusted_root_certificate" {
    for_each = local.trusted_root_certs_names
    content {
      name = trusted_root_certificate.value.certificate_name
      data = data.azurerm_key_vault_secret.this[trusted_root_certificate.value.key].value
    }
  }

  dynamic "http_listener" {
    for_each = coalesce(lookup(each.value, "http_listeners"), [])
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = coalesce(http_listener.value.protocol, "Https")
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      require_sni                    = coalesce(http_listener.value.sni_required, false)
      host_name                      = (coalesce(http_listener.value.listener_type, "Basic") == "MultiSite" && http_listener.value.host_names == null) ? http_listener.value.host_name : null
      host_names                     = (coalesce(http_listener.value.listener_type, "Basic") == "MultiSite" && http_listener.value.host_name == null) ? http_listener.value.host_names : null
#      firewall_policy_id             = http_listener.value.webapp_firewall_policy_key != null ? lookup(azurerm_web_application_firewall_policy.this, http_listener.value.webapp_firewall_policy_key)["id"] : null
    }
  }

  dynamic "request_routing_rule" {
    for_each = coalesce(lookup(each.value, "request_routing_rules"), [])
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = coalesce(request_routing_rule.value.rule_type, "Basic")
      http_listener_name          = request_routing_rule.value.listener_name
      backend_address_pool_name   = request_routing_rule.value.redirect_configuration_name == null ? lookup(request_routing_rule.value, "backend_address_pool_name", null) : null
      backend_http_settings_name  = request_routing_rule.value.redirect_configuration_name == null ? lookup(request_routing_rule.value, "backend_http_settings_name", null) : null
      redirect_configuration_name = (request_routing_rule.value.backend_http_settings_name == null && request_routing_rule.value.backend_address_pool_name == null) ? lookup(request_routing_rule.value, "redirect_configuration_name", null) : null
      url_path_map_name           = coalesce(request_routing_rule.value.rule_type, "Basic") == "PathBasedRouting" ? request_routing_rule.value.url_path_map_name : null
      rewrite_rule_set_name       = lookup(request_routing_rule.value, "rewrite_rule_set_name", null)
    }
  }

  dynamic "url_path_map" {
    for_each = coalesce(lookup(each.value, "url_path_maps"), [])
    content {
      name                                = url_path_map.value.name
      default_backend_http_settings_name  = url_path_map.value.default_redirect_configuration_name == null ? lookup(url_path_map.value, "default_backend_http_settings_name", null) : null
      default_backend_address_pool_name   = url_path_map.value.default_redirect_configuration_name == null ? lookup(url_path_map.value, "default_backend_address_pool_name", null) : null
      default_redirect_configuration_name = (url_path_map.value.default_backend_http_settings_name == null && url_path_map.value.default_backend_address_pool_name == null) ? lookup(url_path_map.value, "default_redirect_configuration_name", null) : null
      default_rewrite_rule_set_name       = lookup(url_path_map.value, "default_rewrite_rule_set_name", null)
      dynamic "path_rule" {
        for_each = coalesce(lookup(url_path_map.value, "path_rules"), [])
        content {
          name                        = path_rule.value.name
          paths                       = path_rule.value.paths
          backend_address_pool_name   = path_rule.value.redirect_configuration_name == null ? lookup(path_rule.value, "backend_address_pool_name", null) : null
          backend_http_settings_name  = path_rule.value.redirect_configuration_name == null ? lookup(path_rule.value, "backend_http_settings_name", null) : null
          redirect_configuration_name = (path_rule.value.backend_http_settings_name == null && path_rule.value.backend_address_pool_name == null) ? lookup(path_rule.value, "redirect_configuration_name", null) : null
          rewrite_rule_set_name       = lookup(path_rule.value, "rewrite_rule_set_name", null)
        }
      }
    }
  }

#  dynamic "waf_configuration" {
#    for_each = each.value["webapp_firewall_policy_key"] == null ? [local.default_waf_configuration] : []
#    content {
#      firewall_mode    = waf_configuration.value.firewall_mode
#      rule_set_type    = waf_configuration.value.rule_set_type
#      rule_set_version = waf_configuration.value.rule_set_version
#      enabled          = waf_configuration.value.enabled
#    }
#  }

#  firewall_policy_id = each.value["webapp_firewall_policy_key"] != null ? lookup(azurerm_web_application_firewall_policy.this, each.value["webapp_firewall_policy_key"])["id"] : null

  dynamic "probe" {
    for_each = coalesce(lookup(each.value, "probes"), [])
    content {
      name                                      = probe.value.name
      path                                      = probe.value.path
      protocol                                  = coalesce(probe.value.protocol, "Https")
      interval                                  = coalesce(probe.value.interval, 30)
      timeout                                   = coalesce(probe.value.timeout, 30)
      unhealthy_threshold                       = coalesce(probe.value.unhealthy_threshold, 3)
      host                                      = coalesce(probe.value.pick_host_name_from_backend_http_settings, false) == false ? probe.value.host : null
      pick_host_name_from_backend_http_settings = coalesce(probe.value.pick_host_name_from_backend_http_settings, false)
    }
  }

  dynamic "redirect_configuration" {
    for_each = coalesce(lookup(each.value, "redirect_configurations"), [])
    content {
      name                 = redirect_configuration.value.name
      redirect_type        = coalesce(redirect_configuration.value.redirect_type, "Permanent")
      target_listener_name = redirect_configuration.value.target_url == null ? lookup(redirect_configuration.value, "target_listener_name", null) : null
      target_url           = redirect_configuration.value.target_listener_name == null ? lookup(redirect_configuration.value, "target_url", null) : null
      include_path         = coalesce(redirect_configuration.value.include_path, false)
      include_query_string = coalesce(redirect_configuration.value.include_query_string, false)
    }
  }

  dynamic "autoscale_configuration" {
    for_each = each.value["autoscale_configuration"] != null ? [each.value["autoscale_configuration"]] : []
    content {
      min_capacity = autoscale_configuration.value.min_capacity
      max_capacity = autoscale_configuration.value.max_capacity
    }
  }

  dynamic "rewrite_rule_set" {
    for_each = coalesce(lookup(each.value, "rewrite_rule_sets"), [])
    content {
      name = rewrite_rule_set.value.name
      dynamic "rewrite_rule" {
        for_each = coalesce(lookup(rewrite_rule_set.value, "rewrite_rules"), [])
        content {
          name          = rewrite_rule.value.name
          rule_sequence = rewrite_rule.value.rule_sequence
          dynamic "condition" {
            for_each = coalesce(lookup(rewrite_rule.value, "conditions"), [])
            content {
              variable    = condition.value.variable
              pattern     = condition.value.pattern
              ignore_case = coalesce(condition.value.ignore_case, false)
              negate      = coalesce(condition.value.negate, false)
            }
          }
          dynamic "request_header_configuration" {
            for_each = coalesce(lookup(rewrite_rule.value, "request_header_configurations"), [])
            content {
              header_name  = request_header_configuration.value.header_name
              header_value = coalesce(request_header_configuration.value.header_value, " ")
            }
          }
          dynamic "response_header_configuration" {
            for_each = coalesce(lookup(rewrite_rule.value, "response_header_configurations"), [])
            content {
              header_name  = response_header_configuration.value.header_name
              header_value = coalesce(response_header_configuration.value.header_value, " ")
            }
          }
        }
      }
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.this[each.key].id]
  }

  dynamic "ssl_certificate" {
    for_each = local.ssl_certs_names
    content {
      name                = ssl_certificate.value.certificate_name
      key_vault_secret_id = coalesce(each.value.key_vault_with_private_endpoint_enabled, true) == false ? data.azurerm_key_vault_secret.ssl[ssl_certificate.value.key].id : null
      data                = coalesce(each.value.key_vault_with_private_endpoint_enabled, true) == true ? data.azurerm_key_vault_secret.ssl[ssl_certificate.value.key].value : null
    }
  }

  ssl_policy {
    disabled_protocols = coalesce(each.value.disabled_ssl_protocols, ["TLSv1_0", "TLSv1_1"])
  }

  tags = local.tags

  depends_on = [
    azurerm_user_assigned_identity.this,
    azurerm_key_vault_access_policy.this,
    azurerm_web_application_firewall_policy.this
  ]
}

# -
# - Create Key Vault Accesss Policy for UserManagedIdentity
# -
resource "azurerm_key_vault_access_policy" "this" {
  provider     = azurerm.ado
  for_each     = var.application_gateways
  key_vault_id = data.azurerm_key_vault.this.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.this[each.key].principal_id

  key_permissions         = ["get"]
  secret_permissions      = ["get"]
  certificate_permissions = ["get"]
  storage_permissions     = ["get"]

  depends_on = [azurerm_user_assigned_identity.this]
}

resource "azurerm_web_application_firewall_policy" "this" {
  for_each            = var.waf_policies
  name                = each.value["name"]
  resource_group_name = data.azurerm_resource_group.this.0.name
  location            = data.azurerm_resource_group.this.0.location

  dynamic "custom_rules" {
    for_each = coalesce(each.value.custom_rules, [])
    content {
      name      = lookup(custom_rules.value, "name", null)
      priority  = custom_rules.value.priority
      rule_type = custom_rules.value.rule_type
      action    = custom_rules.value.action
      dynamic "match_conditions" {
        for_each = coalesce(custom_rules.value.match_conditions, [])
        content {
          dynamic "match_variables" {
            for_each = coalesce(match_conditions.value.match_variables, [])
            content {
              variable_name = match_variables.value.variable_name
              selector      = lookup(match_variables.value, "selector", null)
            }
          }
          operator           = match_conditions.value.operator
          negation_condition = coalesce(match_conditions.value.negation_condition, false)
          match_values       = match_conditions.value.match_values
          transforms         = lookup(match_conditions.value, "transforms", null)
        }
      }
    }
  }

  dynamic "policy_settings" {
    for_each = lookup(each.value, "policy_settings", null) != null ? tolist([lookup(each.value, "policy_settings")]) : []
    content {
      enabled = coalesce(policy_settings.value.enabled, true)
      mode    = coalesce(policy_settings.value.mode, "Prevention")
    }
  }

  dynamic "managed_rules" {
    for_each = lookup(each.value, "managed_rules", null) != null ? tolist([lookup(each.value, "managed_rules")]) : []
    content {
      dynamic "exclusion" {
        for_each = coalesce(managed_rules.value.exclusions, [])
        content {
          match_variable          = exclusion.value.match_variable
          selector                = lookup(exclusion.value, "selector", null)
          selector_match_operator = exclusion.value.selector_match_operator
        }
      }
      dynamic "managed_rule_set" {
        for_each = coalesce(managed_rules.value.managed_rule_sets, [])
        content {
          type    = lookup(managed_rule_set.value, "type", null)
          version = managed_rule_set.value.version
          dynamic "rule_group_override" {
            for_each = coalesce(managed_rule_set.value.rule_group_overrides, [])
            content {
              rule_group_name = rule_group_override.value.rule_group_name
              disabled_rules  = lookup(rule_group_override.value, "disabled_rules", null)
            }
          }
        }
      }
    }
  }

  tags = local.tags
}
