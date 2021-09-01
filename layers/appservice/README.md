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
| [azurerm_app_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service) |
| [azurerm_app_service_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate) |
| [azurerm_app_service_custom_hostname_binding.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) |
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/app_service_plan) |
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) |
| [azurerm_app_service_slot.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_slot) |
| [azurerm_app_service_slot_virtual_network_swift_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_slot_virtual_network_swift_connection) |
| [azurerm_app_service_virtual_network_swift_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_key_vault.ado](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_certificate.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) |
| [azurerm_key_vault_secret.acr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_secret) |
| [azurerm_resource_group.ado](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_storage_account.app_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_storage_account.http_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_storage_account_blob_container_sas.app_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) |
| [azurerm_storage_account_blob_container_sas.http_logs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) |
| [azurerm_storage_account_blob_container_sas.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account_blob_container_sas) |
| [azurerm_subnet.slot_integration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subnet.swift_connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_acr_secret_name"></a> [acr\_secret\_name](#input\_acr\_secret\_name) | key vault secret name of ACR Password | `any` | `null` | no |
| <a name="input_ado_key_vault_name"></a> [ado\_key\_vault\_name](#input\_ado\_key\_vault\_name) | name of the key vault | `any` | `null` | no |
| <a name="input_ado_resource_group_name"></a> [ado\_resource\_group\_name](#input\_ado\_resource\_group\_name) | resource group name of the ado | `any` | `null` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | subscription id in which key vault exist | `any` | n/a | yes |
| <a name="input_app_service_additional_tags"></a> [app\_service\_additional\_tags](#input\_app\_service\_additional\_tags) | Additional tags for the App Service resources, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_app_service_certificate"></a> [app\_service\_certificate](#input\_app\_service\_certificate) | n/a | <pre>map(object({<br>    key_vault_secret_name = string<br>    certificate_name      = string<br>    app_service_key       = string<br>  }))</pre> | `{}` | no |
| <a name="input_app_service_plans"></a> [app\_service\_plans](#input\_app\_service\_plans) | The App Services plans with their properties. | <pre>map(object({<br>    name                         = string<br>    kind                         = string<br>    reserved                     = bool<br>    per_site_scaling             = bool<br>    maximum_elastic_worker_count = number<br>    sku_tier                     = string<br>    sku_size                     = string<br>    sku_capacity                 = number<br>  }))</pre> | `{}` | no |
| <a name="input_app_service_slot"></a> [app\_service\_slot](#input\_app\_service\_slot) | n/a | <pre>map(object({<br>    name                 = string<br>    app_service_key      = string<br>    app_service_plan_key = string<br>  }))</pre> | `{}` | no |
| <a name="input_app_services"></a> [app\_services](#input\_app\_services) | The App Services with their properties. | <pre>map(object({<br>    name                    = string<br>    app_service_plan_key    = string<br>    app_settings            = map(string)<br>    client_affinity_enabled = bool<br>    client_cert_enabled     = bool<br>    enabled                 = bool<br>    https_only              = bool<br>    assign_identity         = bool<br>    enable_monitoring       = bool<br>    add_key_vault_secret    = bool<br>    add_acr_password        = bool<br>    auth_settings = object({<br>      enabled                        = bool<br>      additional_login_params        = map(string)<br>      allowed_external_redirect_urls = list(string)<br>      default_provider               = string<br>      issuer                         = string<br>      runtime_version                = string<br>      token_refresh_extension_hours  = number<br>      token_store_enabled            = bool<br>      unauthenticated_client_action  = string<br>    })<br>    storage_accounts = list(object({<br>      name         = string<br>      type         = string<br>      account_name = string<br>      share_name   = string<br>      access_key   = string<br>      mount_path   = string<br>    }))<br>    backup = object({<br>      name                 = string<br>      enabled              = bool<br>      storage_account_name = string<br>      container_name       = string<br>      schedule = object({<br>        frequency_interval       = number<br>        frequency_unit           = string<br>        keep_at_least_one_backup = bool<br>        retention_period_in_days = number<br>        start_time               = string<br>      })<br>    })<br>    connection_strings = list(object({<br>      name  = string<br>      type  = string<br>      value = string<br>    }))<br>    site_config = object({<br>      always_on                        = bool<br>      app_command_line                 = string<br>      default_documents                = list(string)<br>      dotnet_framework_version         = string<br>      ftps_state                       = string<br>      http2_enabled                    = bool<br>      java_version                     = string<br>      java_container                   = string<br>      java_container_version           = string<br>      local_mysql_enabled              = bool<br>      linux_fx_version                 = string<br>      linux_fx_version_local_file_path = string<br>      windows_fx_version               = string<br>      managed_pipeline_mode            = string<br>      min_tls_version                  = string<br>      php_version                      = string<br>      python_version                   = string<br>      remote_debugging_enabled         = bool<br>      remote_debugging_version         = string<br>      scm_type                         = string<br>      use_32_bit_worker_process        = bool<br>      websockets_enabled               = bool<br>      cors = object({<br>        allowed_origins     = list(string)<br>        support_credentials = bool<br>      })<br>      ip_restriction = list(object({<br>        ip_address  = string<br>        subnet_name = string<br>      }))<br>    })<br>    logs = object({<br>      application_logs = object({<br>        azure_blob_storage = object({<br>          level                = string<br>          storage_account_name = string<br>          container_name       = string<br>          retention_in_days    = number<br>        })<br>      })<br>      http_logs = object({<br>        file_system = object({<br>          retention_in_days = number<br>          retention_in_mb   = number<br>        })<br>        azure_blob_storage = object({<br>          storage_account_name = string<br>          container_name       = string<br>          retention_in_days    = number<br>        })<br>      })<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Specifies the Application Insights Name to collect application monitoring data | `string` | `null` | no |
| <a name="input_appsvc_slot_vnet_integration"></a> [appsvc\_slot\_vnet\_integration](#input\_appsvc\_slot\_vnet\_integration) | n/a | <pre>map(object({<br>    appsvc_slot_key           = string<br>    app_service_key           = string<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | n/a | yes |
| <a name="input_custom_hostname_bindings"></a> [custom\_hostname\_bindings](#input\_custom\_hostname\_bindings) | n/a | <pre>map(object({<br>    kv_cert_name    = string<br>    hostname        = string<br>    app_service_key = string<br>    ssl_state       = string<br>  }))</pre> | `{}` | no |
| <a name="input_existing_app_service_plans"></a> [existing\_app\_service\_plans](#input\_existing\_app\_service\_plans) | Existing App Services plans. | <pre>map(object({<br>    name                = string<br>    resource_group_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_secret_name"></a> [key\_vault\_secret\_name](#input\_key\_vault\_secret\_name) | name of the key vault secret | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the App Services. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vnet_swift_connection"></a> [vnet\_swift\_connection](#input\_vnet\_swift\_connection) | n/a | <pre>map(object({<br>    app_service_key           = string<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_ids_map"></a> [app\_service\_ids\_map](#output\_app\_service\_ids\_map) | Map of the App Service Id's |
| <a name="output_app_service_plans"></a> [app\_service\_plans](#output\_app\_service\_plans) | Map output of the App Service Plans |
| <a name="output_app_services"></a> [app\_services](#output\_app\_services) | Map output of the App Services |
<!-- END_TF_DOCS -->