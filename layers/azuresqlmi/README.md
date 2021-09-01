<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.20.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_template_deployment.sql_mi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [azurerm_template_deployment.sql_mi_db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/template_deployment) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_time_out"></a> [deployment\_time\_out](#input\_deployment\_time\_out) | n/a | `string` | `"8h"` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | name of the key vault | `any` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | name of the location | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which SQL MI needs to be created | `string` | `null` | no |
| <a name="input_sql_mi"></a> [sql\_mi](#input\_sql\_mi) | Map of Azure SQL managed instances | <pre>map(object({<br>    name                        = string<br>    username                    = string<br>    collation                   = string<br>    license_type                = string<br>    vcores                      = number<br>    storage_size_in_gb          = number<br>    minimum_tls_version         = number<br>    skuname                     = string   <br>    subnetname                  = string<br>    deploy_to_existing_subnet   = bool<br>    existing_subnet_name        = string<br>    existing_vnet_name          = string<br>    existing_subnet_rg_name     = string <br>  }))</pre> | `{}` | no |
| <a name="input_sql_mi_db"></a> [sql\_mi\_db](#input\_sql\_mi\_db) | n/a | <pre>map(object({<br>   name = string<br>   sql_mi_name = string<br>   }))</pre> | n/a | yes |
| <a name="input_sql_mi_tags"></a> [sql\_mi\_tags](#input\_sql\_mi\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identity"></a> [identity](#output\_identity) | n/a |
| <a name="output_sqlmi_properties"></a> [sqlmi\_properties](#output\_sqlmi\_properties) | n/a |
<!-- END_TF_DOCS -->