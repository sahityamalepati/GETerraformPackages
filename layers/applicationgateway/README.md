<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.20.0 ~> 2.20.0 |
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.20.0 ~> 2.20.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_application_gateway.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway) |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_secret.ssl](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.frontend_ip_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subnet.gateway_ip_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |
| [azurerm_web_application_firewall_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/web_application_firewall_policy) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | `null` | no |
| <a name="input_app_gateway_additional_tags"></a> [app\_gateway\_additional\_tags](#input\_app\_gateway\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_application_gateways"></a> [application\_gateways](#input\_application\_gateways) | Map containing Application Gateways details | <pre>map(object({<br>    name                       = string<br>    webapp_firewall_policy_key = string<br>    zones                      = list(string)<br>    enable_http2               = bool<br>    sku = object({<br>      name     = string<br>      tier     = string<br>      capacity = number<br>    })<br>    gateway_ip_configurations = list(object({<br>      name                      = string<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>    }))<br>    frontend_ports = list(object({<br>      name = string<br>      port = number<br>    }))<br>    frontend_ip_configurations = list(object({<br>      name                      = string<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>      static_ip                 = string<br>      enable_public_ip          = bool<br>      domain_name_label         = string<br>    }))<br>    backend_address_pools = list(object({<br>      name         = string<br>      fqdns        = list(string)<br>      ip_addresses = list(string)<br>    }))<br>    backend_http_settings = list(object({<br>      name                                = string<br>      cookie_based_affinity               = string<br>      path                                = string<br>      port                                = number<br>      request_timeout                     = number<br>      probe_name                          = string<br>      protocol                            = string<br>      host_name                           = string<br>      pick_host_name_from_backend_address = bool<br>    }))<br>    http_listeners = list(object({<br>      name                           = string<br>      frontend_ip_configuration_name = string<br>      frontend_port_name             = string<br>      ssl_certificate_name           = string<br>      protocol                       = string<br>      sni_required                   = bool<br>      listener_type                  = string       # MultiSite or Basic<br>      host_name                      = string       # Required if listener_type = MultiSite and host_names = null<br>      host_names                     = list(string) # Required if listener_type = MultiSite and host_name = null<br>      webapp_firewall_policy_key     = string       # The Key of the Map of Web Application Firewall Policies which should be used as a HTTP Listener.<br>    }))<br>    request_routing_rules = list(object({<br>      name                        = string<br>      rule_type                   = string<br>      listener_name               = string<br>      backend_address_pool_name   = string<br>      backend_http_settings_name  = string<br>      redirect_configuration_name = string<br>      url_path_map_name           = string<br>      rewrite_rule_set_name       = string<br>    }))<br>    url_path_maps = list(object({<br>      name                                = string<br>      default_backend_http_settings_name  = string<br>      default_backend_address_pool_name   = string<br>      default_redirect_configuration_name = string<br>      default_rewrite_rule_set_name       = string<br>      path_rules = list(object({<br>        name                        = string<br>        paths                       = list(string)<br>        backend_http_settings_name  = string<br>        backend_address_pool_name   = string<br>        redirect_configuration_name = string<br>        rewrite_rule_set_name       = string<br>      }))<br>    }))<br>    probes = list(object({<br>      name                                      = string<br>      path                                      = string<br>      interval                                  = number<br>      protocol                                  = string<br>      timeout                                   = number<br>      unhealthy_threshold                       = number<br>      host                                      = string<br>      pick_host_name_from_backend_http_settings = bool<br>    }))<br>    redirect_configurations = list(object({<br>      name                 = string<br>      redirect_type        = string<br>      target_listener_name = string<br>      target_url           = string<br>      include_path         = bool<br>      include_query_string = bool<br>    }))<br>    rewrite_rule_sets = list(object({<br>      name = string<br>      rewrite_rules = list(object({<br>        name          = string<br>        rule_sequence = number<br>        conditions = list(object({<br>          variable    = string<br>          pattern     = string<br>          ignore_case = bool<br>          negate      = bool<br>        }))<br>        request_header_configurations = list(object({<br>          header_name  = string<br>          header_value = string<br>        }))<br>        response_header_configurations = list(object({<br>          header_name  = string<br>          header_value = string<br>        }))<br>      }))<br>    }))<br>    disabled_ssl_protocols                  = list(string)<br>    trusted_root_certificate_names          = list(string)<br>    ssl_certificate_names                   = list(string)<br>    key_vault_with_private_endpoint_enabled = bool<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the Key Vault name where SSL Certificate exists | `string` | `null` | no |
| <a name="input_key_vault_resource_group"></a> [key\_vault\_resource\_group](#input\_key\_vault\_resource\_group) | Specifies the Resource Group name where source Key Vault exists | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Application Gateway component. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_waf_policies"></a> [waf\_policies](#input\_waf\_policies) | Map containing Web Application Firewall details | <pre>map(object({<br>    name = string<br>    custom_rules = list(object({<br>      name      = string<br>      priority  = number<br>      rule_type = string<br>      action    = string<br>      match_conditions = list(object({<br>        match_variables = list(object({<br>          variable_name = string<br>          selector      = string<br>        }))<br>        operator           = string<br>        negation_condition = bool<br>        match_values       = list(string)<br>        transforms         = list(string)<br>      }))<br>    }))<br>    policy_settings = object({<br>      enabled = bool<br>      mode    = string<br>    })<br>    managed_rules = object({<br>      exclusions = list(object({<br>        match_variable          = string<br>        selector                = string<br>        selector_match_operator = string<br>      }))<br>      managed_rule_sets = list(object({<br>        type    = string<br>        version = string<br>        rule_group_overrides = list(object({<br>          rule_group_name = string<br>          disabled_rules  = list(string)<br>        }))<br>      }))<br>    })<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_gateway_backend_pool_ids_map"></a> [application\_gateway\_backend\_pool\_ids\_map](#output\_application\_gateway\_backend\_pool\_ids\_map) | n/a |
| <a name="output_application_gateway_backend_pools"></a> [application\_gateway\_backend\_pools](#output\_application\_gateway\_backend\_pools) | n/a |
| <a name="output_application_gateway_backend_pools_map"></a> [application\_gateway\_backend\_pools\_map](#output\_application\_gateway\_backend\_pools\_map) | n/a |
| <a name="output_application_gateway_ids"></a> [application\_gateway\_ids](#output\_application\_gateway\_ids) | n/a |
| <a name="output_application_gateway_ids_map"></a> [application\_gateway\_ids\_map](#output\_application\_gateway\_ids\_map) | n/a |
| <a name="output_frontend_ips_map"></a> [frontend\_ips\_map](#output\_frontend\_ips\_map) | n/a |
<!-- END_TF_DOCS -->