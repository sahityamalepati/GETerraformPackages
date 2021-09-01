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
| [azurerm_mysql_configuration.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_configuration) |
| [azurerm_mysql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_database) |
| [azurerm_mysql_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_firewall_rule) |
| [azurerm_mysql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_server) |
| [azurerm_mysql_virtual_network_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_virtual_network_rule) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_administrator_login_name"></a> [administrator\_login\_name](#input\_administrator\_login\_name) | The administrator username of MySQL Server | `string` | `"dbadmin"` | no |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The administrator password of the MySQL Server | `string` | `null` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | The List of networks that the MySQL server will be connected to. | <pre>list(object({<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | `[]` | no |
| <a name="input_assign_identity"></a> [assign\_identity](#input\_assign\_identity) | Specifies whether to enable Managed System Identity for the MySQL Server | `bool` | `true` | no |
| <a name="input_auto_grow_enabled"></a> [auto\_grow\_enabled](#input\_auto\_grow\_enabled) | Enable/Disable auto-growing of the storage. Storage auto-grow prevents your server from running out of storage and becoming read-only. If storage auto grow is enabled, the storage automatically grows without impacting the workload. The default value if not explicitly specified is true. | `bool` | `true` | no |
| <a name="input_backup_retention_days"></a> [backup\_retention\_days](#input\_backup\_retention\_days) | Backup retention days for the server, supported values are between 7 and 35 days. | `number` | `7` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The creation mode. Can be used to restore or replicate existing servers. Possible values are Default, Replica, GeoRestore, and PointInTimeRestore. Defaults to Default. | `string` | `"Default"` | no |
| <a name="input_creation_source_server_id"></a> [creation\_source\_server\_id](#input\_creation\_source\_server\_id) | For creation modes other than Default, the source server ID to use. | `string` | `null` | no |
| <a name="input_database_names"></a> [database\_names](#input\_database\_names) | List of MySQL database names | `list(string)` | n/a | yes |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of MySQL Server firewall rule specification | <pre>map(object({<br>    name             = string # (Required) Specifies the name of the MySQL Firewall Rule. <br>    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule<br>    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule<br>  }))</pre> | <pre>{<br>  "default": {<br>    "end_ip_address": "0.0.0.0",<br>    "name": "mysql-firewall-rule-default",<br>    "start_ip_address": "0.0.0.0"<br>  }<br>}</pre> | no |
| <a name="input_geo_redundant_backup_enabled"></a> [geo\_redundant\_backup\_enabled](#input\_geo\_redundant\_backup\_enabled) | Turn Geo-redundant server backups on/off. This allows you to choose between locally redundant or geo-redundant backup storage in the General Purpose and Memory Optimized tiers. When the backups are stored in geo-redundant backup storage, they are not only stored within the region in which your server is hosted, but are also replicated to a paired data center. This provides better protection and ability to restore your server in a different region in the event of a disaster. This is not supported for the Basic tier. | `bool` | `false` | no |
| <a name="input_infrastructure_encryption_enabled"></a> [infrastructure\_encryption\_enabled](#input\_infrastructure\_encryption\_enabled) | Whether or not infrastructure is encrypted for this server. Defaults to false. Changing this forces a new resource to be created. | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store MySQL Server Password. | `string` | `null` | no |
| <a name="input_mysql_additional_tags"></a> [mysql\_additional\_tags](#input\_mysql\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | <pre>{<br>  "pe_enable": true<br>}</pre> | no |
| <a name="input_mysql_configurations"></a> [mysql\_configurations](#input\_mysql\_configurations) | Map of MySQL configuration settings to create. Key is name, value is server parameter value | `map(any)` | `{}` | no |
| <a name="input_mysql_version"></a> [mysql\_version](#input\_mysql\_version) | Specifies the version of MySQL to use. Valid values are 5.6, 5.7, and 8.0 | `string` | `"5.7"` | no |
| <a name="input_private_endpoint_connection_enabled"></a> [private\_endpoint\_connection\_enabled](#input\_private\_endpoint\_connection\_enabled) | Specify if only private endpoint connections will be allowed to access this resource | `bool` | `true` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the MySQL Server | `string` | n/a | yes |
| <a name="input_restore_point_in_time"></a> [restore\_point\_in\_time](#input\_restore\_point\_in\_time) | When create\_mode is PointInTimeRestore, specifies the point in time to restore from creation\_source\_server\_id. | `string` | `null` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the MyQL Server | `string` | n/a | yes |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the SKU Name for this MySQL Server | `string` | `"GP_Gen5_2"` | no |
| <a name="input_ssl_minimal_tls_version"></a> [ssl\_minimal\_tls\_version](#input\_ssl\_minimal\_tls\_version) | The minimum TLS version to support on the sever. Possible values are TLSEnforcementDisabled, TLS1\_0, TLS1\_1, and TLS1\_2. Defaults to TLSEnforcementDisabled. | `string` | `"TLSEnforcementDisabled"` | no |
| <a name="input_storage_mb"></a> [storage\_mb](#input\_storage\_mb) | Max storage allowed for a server. Possible values are between 5120 MB(5GB) and 1048576 MB(1TB) for the Basic SKU and between 5120 MB(5GB) and 4194304 MB(4TB) for General Purpose/Memory Optimized SKUs. | `number` | `5120` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_username"></a> [admin\_username](#output\_admin\_username) | The administrator username of MySQL Server |
| <a name="output_mysql_database_ids"></a> [mysql\_database\_ids](#output\_mysql\_database\_ids) | The list of all MySQL database resource ids |
| <a name="output_mysql_databases_names"></a> [mysql\_databases\_names](#output\_mysql\_databases\_names) | List of all MySQL database resource names |
| <a name="output_mysql_firewall_rule_ids"></a> [mysql\_firewall\_rule\_ids](#output\_mysql\_firewall\_rule\_ids) | List of MySQL Firewall Rule resource ids |
| <a name="output_mysql_fqdn"></a> [mysql\_fqdn](#output\_mysql\_fqdn) | The FQDN of MySQL Server |
| <a name="output_mysql_server_id"></a> [mysql\_server\_id](#output\_mysql\_server\_id) | The server id of MySQL Server |
| <a name="output_mysql_server_name"></a> [mysql\_server\_name](#output\_mysql\_server\_name) | The server name of MySQL Server |
| <a name="output_mysql_vnet_rule_ids"></a> [mysql\_vnet\_rule\_ids](#output\_mysql\_vnet\_rule\_ids) | The list of all MySQL VNet Rule resource ids |
<!-- END_TF_DOCS -->