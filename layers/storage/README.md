<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.31.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.31.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.31.1 ~> 2.31.1 |
| <a name="provider_azurerm.ado"></a> [azurerm.ado](#provider\_azurerm.ado) | ~> 2.31.1 ~> 2.31.1 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) |
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) |
| [azurerm_resource_group.ado_rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) |
| [azurerm_storage_account_customer_managed_key.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account_customer_managed_key) |
| [azurerm_storage_blob.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_blob) |
| [azurerm_storage_container.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_container) |
| [azurerm_storage_queue.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_queue) |
| [azurerm_storage_share.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share) |
| [azurerm_storage_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_table) |
| [azurerm_subnet.ado_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_ado_private_endpoints"></a> [ado\_private\_endpoints](#input\_ado\_private\_endpoints) | Map containing Private Endpoint and Private DNS Zone details | <pre>map(object({<br>    name          = string<br>    resource_name = string<br>    group_ids     = list(string)<br>    dns_zone_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_ado_resource_group_name"></a> [ado\_resource\_group\_name](#input\_ado\_resource\_group\_name) | Specifies the existing ado agent resource group name | `string` | `null` | no |
| <a name="input_ado_subnet_name"></a> [ado\_subnet\_name](#input\_ado\_subnet\_name) | Specifies the existing ado agent subnet name | `string` | `null` | no |
| <a name="input_ado_subscription_id"></a> [ado\_subscription\_id](#input\_ado\_subscription\_id) | Specifies the ado subscription id | `string` | `null` | no |
| <a name="input_ado_vnet_name"></a> [ado\_vnet\_name](#input\_ado\_vnet\_name) | Specifies the existing ado agent virtual network name | `string` | `null` | no |
| <a name="input_blobs"></a> [blobs](#input\_blobs) | Map of Storage Blobs | <pre>map(object({<br>    name                   = string<br>    storage_account_name   = string<br>    storage_container_name = string<br>    type                   = string<br>    size                   = number<br>    content_type           = string<br>    source_uri             = string<br>    metadata               = map(any)<br>  }))</pre> | `{}` | no |
| <a name="input_containers"></a> [containers](#input\_containers) | Map of Storage Containers | <pre>map(object({<br>    name                  = string<br>    storage_account_name  = string<br>    container_access_type = string<br>  }))</pre> | `{}` | no |
| <a name="input_file_shares"></a> [file\_shares](#input\_file\_shares) | Map of Storages File Shares | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>    quota                = number<br>  }))</pre> | `{}` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store Storage Account Primary Access Key. | `string` | `null` | no |
| <a name="input_persist_access_key"></a> [persist\_access\_key](#input\_persist\_access\_key) | Store Storage Account Primary Access Key to Key Vault? | `bool` | `true` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Map of Storages Queues | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the storage account | `string` | n/a | yes |
| <a name="input_sa_additional_tags"></a> [sa\_additional\_tags](#input\_sa\_additional\_tags) | Tags of the SA in addition to the resource group tag. | `map(string)` | <pre>{<br>  "pe_enable": true<br>}</pre> | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | Map of storage accouts which needs to be created in a resource group | <pre>map(object({<br>    name                     = string<br>    sku                      = string<br>    account_kind             = string<br>    access_tier              = string<br>    assign_identity          = bool<br>    cmk_enable               = bool<br>    min_tls_version          = string<br>    large_file_share_enabled = bool<br>    network_rules = object({<br>      bypass                     = list(string) # (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None.<br>      default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.<br>      ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.<br>      virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tables"></a> [tables](#input\_tables) | Map of Storage Tables | <pre>map(object({<br>    name                 = string<br>    storage_account_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_blob_ids"></a> [blob\_ids](#output\_blob\_ids) | n/a |
| <a name="output_blob_urls"></a> [blob\_urls](#output\_blob\_urls) | n/a |
| <a name="output_container_ids"></a> [container\_ids](#output\_container\_ids) | n/a |
| <a name="output_file_share_ids"></a> [file\_share\_ids](#output\_file\_share\_ids) | n/a |
| <a name="output_file_share_urls"></a> [file\_share\_urls](#output\_file\_share\_urls) | n/a |
| <a name="output_primary_access_keys"></a> [primary\_access\_keys](#output\_primary\_access\_keys) | n/a |
| <a name="output_primary_access_keys_map"></a> [primary\_access\_keys\_map](#output\_primary\_access\_keys\_map) | n/a |
| <a name="output_primary_blob_connection_strings_map"></a> [primary\_blob\_connection\_strings\_map](#output\_primary\_blob\_connection\_strings\_map) | n/a |
| <a name="output_primary_blob_endpoints"></a> [primary\_blob\_endpoints](#output\_primary\_blob\_endpoints) | n/a |
| <a name="output_primary_blob_endpoints_map"></a> [primary\_blob\_endpoints\_map](#output\_primary\_blob\_endpoints\_map) | n/a |
| <a name="output_primary_connection_strings"></a> [primary\_connection\_strings](#output\_primary\_connection\_strings) | n/a |
| <a name="output_primary_connection_strings_map"></a> [primary\_connection\_strings\_map](#output\_primary\_connection\_strings\_map) | n/a |
| <a name="output_sa_ids"></a> [sa\_ids](#output\_sa\_ids) | n/a |
| <a name="output_sa_ids_map"></a> [sa\_ids\_map](#output\_sa\_ids\_map) | n/a |
| <a name="output_sa_names"></a> [sa\_names](#output\_sa\_names) | n/a |
<!-- END_TF_DOCS -->