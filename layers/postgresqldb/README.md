<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 0.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 2.23.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_postgresql_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_configuration) |
| [azurerm_postgresql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_database) |
| [azurerm_postgresql_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_firewall_rule) |
| [azurerm_postgresql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_server) |
| [azurerm_postgresql_virtual_network_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_virtual_network_rule) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_creation_source_server_id"></a> [creation\_source\_server\_id](#input\_creation\_source\_server\_id) | For creation modes other then default the source server ID to use. | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store PostgreSql Server Password. | `string` | `null` | no |
| <a name="input_postgresql_additional_tags"></a> [postgresql\_additional\_tags](#input\_postgresql\_additional\_tags) | Additional resource tags for PostgreSql Server | `map(string)` | <pre>{<br>  "pe_enable": true<br>}</pre> | no |
| <a name="input_postgresql_configurations"></a> [postgresql\_configurations](#input\_postgresql\_configurations) | Specifies the PostgreSql Configurations | <pre>map(object({<br>    name       = string<br>    server_key = string<br>    value      = string<br>  }))</pre> | `{}` | no |
| <a name="input_postgresql_databases"></a> [postgresql\_databases](#input\_postgresql\_databases) | Specifies the map of attributes for PostgreSql Database. | <pre>map(object({<br>    name       = string<br>    server_key = string<br>  }))</pre> | `{}` | no |
| <a name="input_postgresql_servers"></a> [postgresql\_servers](#input\_postgresql\_servers) | Specifies the map of attributes for PostgreSql Server. | <pre>map(object({<br>    name                             = string<br>    sku_name                         = string<br>    storage_mb                       = number<br>    backup_retention_days            = number<br>    enable_geo_redundant_backup      = bool<br>    enable_auto_grow                 = bool<br>    administrator_login              = string<br>    administrator_login_password     = string<br>    version                          = number<br>    enable_ssl_enforcement           = bool<br>    create_mode                      = string<br>    enable_public_network_access     = bool<br>    ssl_minimal_tls_version_enforced = string<br>    assign_identity                  = bool<br>    allowed_networks = list(object({<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>    }))<br>    firewall_rules = list(object({<br>      name             = string # (Required) Specifies the name of the Postgrey SQL Firewall Rule. <br>      start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule<br>      end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the Name of the resource group in which PostgreSql should be deployed | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql_id"></a> [postgresql\_id](#output\_postgresql\_id) | n/a |
| <a name="output_postgresql_ids_map"></a> [postgresql\_ids\_map](#output\_postgresql\_ids\_map) | n/a |
| <a name="output_postgresql_names"></a> [postgresql\_names](#output\_postgresql\_names) | n/a |
<!-- END_TF_DOCS -->