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
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) |
| [azurerm_key_vault.secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) |
| [azurerm_key_vault_access_policy.secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_access_policy.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) |
| [azurerm_key_vault_key.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) |
| [azurerm_key_vault_secret.azuresql_keyvault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) |
| [azurerm_mssql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) |
| [azurerm_mssql_server.sqlserver_secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) |
| [azurerm_mssql_server.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) |
| [azurerm_mssql_server_extended_auditing_policy.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) |
| [azurerm_mssql_server_extended_auditing_policy.secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_extended_auditing_policy) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_role_assignment.cmk_primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_assignment.cmk_secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_assignment.primary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_assignment.secondary](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_sql_failover_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_failover_group) |
| [azurerm_sql_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_firewall_rule) |
| [azurerm_sql_virtual_network_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_virtual_network_rule) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |
| [null_resource.cmk_primary](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [null_resource.cmk_secondary](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_password.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_administrator_login_name"></a> [administrator\_login\_name](#input\_administrator\_login\_name) | The administrator username of Azure SQL Server | `string` | `"dbadmin"` | no |
| <a name="input_administrator_login_password"></a> [administrator\_login\_password](#input\_administrator\_login\_password) | The administrator password of the Azure SQL Server | `string` | `null` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | The List of networks that the Azure SQL server will be connected to. | <pre>list(object({<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | `[]` | no |
| <a name="input_assign_identity"></a> [assign\_identity](#input\_assign\_identity) | Specifies whether to enable Managed System Identity for the Azure SQL Server | `bool` | `true` | no |
| <a name="input_auditing_retention_in_days"></a> [auditing\_retention\_in\_days](#input\_auditing\_retention\_in\_days) | Specifies the number of days to retain logs for in the storage account. | `string` | `"6"` | no |
| <a name="input_auditing_storage_account_name"></a> [auditing\_storage\_account\_name](#input\_auditing\_storage\_account\_name) | Specifies the existing storage account name where you want to store AZ Sql auditing logs. | `string` | `null` | no |
| <a name="input_azuresql_additional_tags"></a> [azuresql\_additional\_tags](#input\_azuresql\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | <pre>{<br>  "pe_enable": true<br>}</pre> | no |
| <a name="input_azuresql_version"></a> [azuresql\_version](#input\_azuresql\_version) | Specifies the version of Azure SQL Server ti use. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server) | `string` | `"12.0"` | no |
| <a name="input_cmk_enabled_transparent_data_encryption"></a> [cmk\_enabled\_transparent\_data\_encryption](#input\_cmk\_enabled\_transparent\_data\_encryption) | Enable Azure SQL Transparent Data Encryption (TDE) with customer-managed key? | `bool` | `false` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary. | `string` | `null` | no |
| <a name="input_creation_source_database_id"></a> [creation\_source\_database\_id](#input\_creation\_source\_database\_id) | The id of the source database to be referred to create the new database. This should only be used for databases with create\_mode values that use another database as reference. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_database_names"></a> [database\_names](#input\_database\_names) | List of Azure SQL database names | `list(string)` | `[]` | no |
| <a name="input_elastic_pool_id"></a> [elastic\_pool\_id](#input\_elastic\_pool\_id) | Specifies the ID of the elastic pool containing this database. | `string` | `null` | no |
| <a name="input_enable_failover_server"></a> [enable\_failover\_server](#input\_enable\_failover\_server) | If set to true, enable failover Azure SQL Server | `bool` | `false` | no |
| <a name="input_failover_location"></a> [failover\_location](#input\_failover\_location) | Specifies the supported Azure location where the failover Azure SQL Server exists | `string` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of Azure SQL Server firewall rule specification | <pre>map(object({<br>    name             = string # (Required) Specifies the name of the Azure SQL Firewall Rule. <br>    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule<br>    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule<br>  }))</pre> | `{}` | no |
| <a name="input_geo_secondary_key_vault_name"></a> [geo\_secondary\_key\_vault\_name](#input\_geo\_secondary\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store CMK Key for secondary region. | `string` | `null` | no |
| <a name="input_geo_secondary_key_vault_rg_name"></a> [geo\_secondary\_key\_vault\_rg\_name](#input\_geo\_secondary\_key\_vault\_rg\_name) | Specifies the existing Resource Group Name for Key Vault where you want to store CMK Key for secondary region. | `string` | `null` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Specifies the existing Key Vault Name where you want to store AZ Sql Server Password and CMK Key. | `string` | `null` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | The max size of the database in gigabytes | `number` | `4` | no |
| <a name="input_minimum_tls_version"></a> [minimum\_tls\_version](#input\_minimum\_tls\_version) | The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2. | `string` | `"1.2"` | no |
| <a name="input_private_endpoint_connection_enabled"></a> [private\_endpoint\_connection\_enabled](#input\_private\_endpoint\_connection\_enabled) | Specify if only private endpoint connections will be allowed to access this resource | `bool` | `true` | no |
| <a name="input_read_write_endpoint_failover_policy_mode"></a> [read\_write\_endpoint\_failover\_policy\_mode](#input\_read\_write\_endpoint\_failover\_policy\_mode) | The failover mode. Possible values are Manual, Automatic | `string` | `"Automatic"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the MySQL Server | `string` | n/a | yes |
| <a name="input_restore_point_in_time"></a> [restore\_point\_in\_time](#input\_restore\_point\_in\_time) | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create\_mode= PointInTimeRestore databases. | `string` | `null` | no |
| <a name="input_server_name"></a> [server\_name](#input\_server\_name) | The name of the Azure SQL Server | `string` | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | Specifies the name of the sku used by the database. Changing this forces a new resource to be created. For example, GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100. | `string` | `"BC_Gen5_2"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_azuresql_database_connection_strings"></a> [azuresql\_database\_connection\_strings](#output\_azuresql\_database\_connection\_strings) | Connection strings for the Azure SQL Databases created. |
| <a name="output_azuresql_databases_ids"></a> [azuresql\_databases\_ids](#output\_azuresql\_databases\_ids) | The list of all Azure SQL database resource ids |
| <a name="output_azuresql_databases_ids_map"></a> [azuresql\_databases\_ids\_map](#output\_azuresql\_databases\_ids\_map) | The map of all Azure SQL database resource ids |
| <a name="output_azuresql_databases_names"></a> [azuresql\_databases\_names](#output\_azuresql\_databases\_names) | List of all Azure SQL database resource names |
| <a name="output_azuresql_fqdn"></a> [azuresql\_fqdn](#output\_azuresql\_fqdn) | The fully qualified domain name of the Azure SQL Server |
| <a name="output_azuresql_server_id"></a> [azuresql\_server\_id](#output\_azuresql\_server\_id) | The server id of Azure SQL Server |
| <a name="output_azuresql_server_name"></a> [azuresql\_server\_name](#output\_azuresql\_server\_name) | The server name of Azure SQL Server |
| <a name="output_azuresql_version"></a> [azuresql\_version](#output\_azuresql\_version) | The version of the Azure SQL Server. |
<!-- END_TF_DOCS -->