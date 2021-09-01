<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.20.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.20.0 ~> 2.20.0 |
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.20.0 ~> 2.20.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/container_registry) |
| [azurerm_container_registry.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [azurerm_user_assigned_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) |
| [null_resource.cmk](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [null_resource.network_rule](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [null_resource.replication](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_acr_additional_tags"></a> [acr\_additional\_tags](#input\_acr\_additional\_tags) | Additional tags for the Azure Container Registry resource, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_admin_enabled"></a> [admin\_enabled](#input\_admin\_enabled) | Specifies whether the admin user is enabled. | `bool` | `false` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | `null` | no |
| <a name="input_allowed_external_subnets"></a> [allowed\_external\_subnets](#input\_allowed\_external\_subnets) | Specifies the list of subnets from which requests will match the network rule. | `list(string)` | `[]` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | Specifies the list of netowrks from which requests will match the network rule. | <pre>list(object({<br>    subnet_name = string<br>    vnet_name   = string<br>  }))</pre> | `null` | no |
| <a name="input_assign_identity"></a> [assign\_identity](#input\_assign\_identity) | Specifies whether to enable Managed System Identity for the Azure Container Registry. | `bool` | `true` | no |
| <a name="input_enable_cmk"></a> [enable\_cmk](#input\_enable\_cmk) | Specifies whether to enable Customer Managed Identity for the Azure Container Registry. | `bool` | `false` | no |
| <a name="input_georeplication_locations"></a> [georeplication\_locations](#input\_georeplication\_locations) | A list of Azure locations where the container registry should be geo-replicated. | `list(string)` | `[]` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the Key Vault name where CMK Keys exists | `string` | `null` | no |
| <a name="input_key_vault_resource_group"></a> [key\_vault\_resource\_group](#input\_key\_vault\_resource\_group) | Specifies the Resource Group name where source Key Vault used for CMK exists | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Azure Container Registery Name | `string` | n/a | yes |
| <a name="input_private_endpoint_connection_enabled"></a> [private\_endpoint\_connection\_enabled](#input\_private\_endpoint\_connection\_enabled) | Specifies whether the Private Endpoint Connection is enabled or not. | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Azure Container Registry. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | Azure Container Registery SKU. Possible values are Basic, Standard and Premium. | `string` | `"Premium"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_fqdn"></a> [acr\_fqdn](#output\_acr\_fqdn) | The Container Registry FQDN. |
| <a name="output_acr_id"></a> [acr\_id](#output\_acr\_id) | The Container Registry ID. |
| <a name="output_acr_name"></a> [acr\_name](#output\_acr\_name) | The Container Registry name. |
| <a name="output_admin_password"></a> [admin\_password](#output\_admin\_password) | The Password associated with the Container Registry Admin account - if the admin account is enabled. |
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The Username associated with the Container Registry Admin account - if the admin account is enabled. |
| <a name="output_login_server"></a> [login\_server](#output\_login\_server) | The URL that can be used to log into the container registry. |
<!-- END_TF_DOCS -->