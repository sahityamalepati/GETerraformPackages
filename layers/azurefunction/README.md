<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.31.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/app_service_plan) |
| [azurerm_app_service_plan.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_plan) |
| [azurerm_app_service_virtual_network_swift_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_virtual_network_swift_connection) |
| [azurerm_application_insights.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/application_insights) |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_function_app.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/function_app) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_subscription.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_app_service_plans"></a> [app\_service\_plans](#input\_app\_service\_plans) | The App Services plans with their properties. | <pre>map(object({<br>    name                         = string<br>    kind                         = string<br>    reserved                     = bool<br>    per_site_scaling             = bool<br>    maximum_elastic_worker_count = number<br>    sku_tier                     = string<br>    sku_size                     = string<br>    sku_capacity                 = number<br>  }))</pre> | `{}` | no |
| <a name="input_application_insights_name"></a> [application\_insights\_name](#input\_application\_insights\_name) | Specifies the Application Insights Name to collect application monitoring data | `string` | `null` | no |
| <a name="input_create_role_assignment"></a> [create\_role\_assignment](#input\_create\_role\_assignment) | Specifies whether a role assignment will be created for the Az Function Identity, if true, role\_assignment\_name is required | `bool` | `false` | no |
| <a name="input_existing_app_service_plans"></a> [existing\_app\_service\_plans](#input\_existing\_app\_service\_plans) | Existing App Services plans. | <pre>map(object({<br>    name                = string<br>    resource_group_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_function_app_additional_tags"></a> [function\_app\_additional\_tags](#input\_function\_app\_additional\_tags) | Additional tags for the Azure Function App resources, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_function_apps"></a> [function\_apps](#input\_function\_apps) | The App Services with their properties. | <pre>map(object({<br>    name                    = string<br>    app_service_plan_key    = string<br>    storage_account_name    = string<br>    app_settings            = map(string)<br>    os_type                 = string<br>    client_affinity_enabled = bool<br>    enabled                 = bool<br>    https_only              = bool<br>    assign_identity         = bool<br>    version                 = string<br>    enable_monitoring       = bool<br>    auth_settings = object({<br>      enabled                        = bool<br>      additional_login_params        = map(string)<br>      allowed_external_redirect_urls = list(string)<br>      default_provider               = string<br>      issuer                         = string<br>      runtime_version                = string<br>      token_refresh_extension_hours  = number<br>      token_store_enabled            = bool<br>      unauthenticated_client_action  = string<br>      active_directory = object({<br>        #client_id         = string<br>        #client_secret     = string<br>        allowed_audiences = list(string)<br>      })<br>      microsoft = object({<br>        #client_id     = string<br>        #client_secret = string<br>        oauth_scopes  = list(string)<br>      })<br>    })<br>    connection_strings = list(object({<br>      name  = string<br>      type  = string<br>      value = string<br>    }))<br>    site_config = object({<br>      always_on                        = bool<br>      ftps_state                       = string<br>      http2_enabled                    = bool<br>      linux_fx_version                 = string<br>      linux_fx_version_local_file_path = string<br>      min_tls_version                  = string<br>      websockets_enabled               = bool<br>      use_32_bit_worker_process        = bool<br>      cors = object({<br>        allowed_origins     = list(string)<br>        support_credentials = bool<br>      })<br>      ip_restrictions = list(object({<br>        ip_address                = string<br>        virtual_network_subnet_id = string<br>        subnet_id                 = string<br>        subnet_mask               = string<br>        name                      = string<br>        priority                  = number<br>        action                    = string<br>      }))<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where CMK Keys are stored. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the App Services. | `string` | n/a | yes |
| <a name="input_role_assignment_names"></a> [role\_assignment\_names](#input\_role\_assignment\_names) | The subscription role assignment name to be used for the az function identity | `list(string)` | `[]` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vnet_swift_connection"></a> [vnet\_swift\_connection](#input\_vnet\_swift\_connection) | Map of Azure Function Virtual Network Association objects | <pre>map(object({<br>    function_app_key          = string<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_service_plans"></a> [app\_service\_plans](#output\_app\_service\_plans) | Map output of the App Service Plans |
| <a name="output_function_apps"></a> [function\_apps](#output\_function\_apps) | Map output of the Azure Function Apps |
<!-- END_TF_DOCS -->