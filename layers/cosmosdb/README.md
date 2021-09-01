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

## Modules

No modules.

## Resources

| Name |
|------|
| [azurerm_cosmosdb_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_account) |
| [azurerm_cosmosdb_cassandra_keyspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_cassandra_keyspace) |
| [azurerm_cosmosdb_mongo_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_collection) |
| [azurerm_cosmosdb_mongo_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_mongo_database) |
| [azurerm_cosmosdb_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/cosmosdb_table) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_allowed_networks"></a> [allowed\_networks](#input\_allowed\_networks) | The List of networks that the CosmosDB Account will be connected to. | <pre>list(object({<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>  }))</pre> | `[]` | no |
| <a name="input_cosmosdb_account"></a> [cosmosdb\_account](#input\_cosmosdb\_account) | Map that holds the Azure CcosmosDB Account configuration | <pre>object({<br>    database_name                     = string # (Required) Specifies the name of the CosmosDB Account. <br>    offer_type                        = string # (Required) Specifies the Offer Type to use for this CosmosDB Account - currently this can only be set to Standard.<br>    kind                              = string # (Optional) Specifies the Kind of CosmosDB to create - possible values are GlobalDocumentDB and MongoDB. Defaults to GlobalDocumentDB. <br>    enable_multiple_write_locations   = bool   # (Optional) Enable multi-master support for this Cosmos DB account.<br>    enable_automatic_failover         = bool   # (Optional) Enable automatic fail over for this Cosmos DB account.<br>    is_virtual_network_filter_enabled = bool   # (Optional) Enables virtual network filtering for this Cosmos DB account.<br>    ip_range_filter                   = string # (Optional) This value specifies the set of IP addresses or IP address ranges in CIDR form to be included as the allowed list of client IP's for a given database account. IP addresses/ranges must be comma separated and must not contain any spaces.<br>    api_type                          = string # (Optional) The capabilities which should be enabled for this Cosmos DB account. Possible values are EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableTable, MongoDBv3.4, and mongoEnableDocLevelTTL.<br>    consistency_level                 = string # (Required) The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix.<br>    max_interval_in_seconds           = number # (Optional) When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated. Accepted range for this value is 5 - 86400 (1 day). Defaults to 5. Required when consistency_level is set to BoundedStaleness.<br>    max_staleness_prefix              = number # (Optional) When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated. Accepted range for this value is 10 – 2147483647. Defaults to 100. Required when consistency_level is set to BoundedStaleness.<br>    failover_location                 = string # (Required) The name of the Azure region to host replicated data.<br>  })</pre> | `null` | no |
| <a name="input_cosmosdb_additional_tags"></a> [cosmosdb\_additional\_tags](#input\_cosmosdb\_additional\_tags) | A mapping of tags to assign to the resource | `map(string)` | <pre>{<br>  "pe_enable": true<br>}</pre> | no |
| <a name="input_default_ttl_seconds"></a> [default\_ttl\_seconds](#input\_default\_ttl\_seconds) | The default Time To Live in seconds. If the value is -1 or 0, items are not automatically expired. | `string` | `"777"` | no |
| <a name="input_indexes"></a> [indexes](#input\_indexes) | Specifies the list of Cosmos MongoDB Collection indexes | <pre>list(object({<br>    keys   = list(string)<br>    unique = bool<br>  }))</pre> | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Azure CosmosDB | `string` | n/a | yes |
| <a name="input_shard_key"></a> [shard\_key](#input\_shard\_key) | The name of the key to partition on for sharding. There must not be any other unique index keys. | `string` | `"uniqueKey"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_throughput"></a> [throughput](#input\_throughput) | The throughput of Mongo Collection/Cassandra Keyspace/Table (RU/s). Must be set in increments of 100. The minimum value is 400. This must be set upon database creation otherwise it cannot be updated without a manual terraform destroy-apply. | `number` | `400` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cassandra_api_id"></a> [cassandra\_api\_id](#output\_cassandra\_api\_id) | The Cosmos DB Cassandra KeySpace Id |
| <a name="output_cosmosdb_endpoint"></a> [cosmosdb\_endpoint](#output\_cosmosdb\_endpoint) | The endpoint used to connect to the CosmosDB Account |
| <a name="output_cosmosdb_id"></a> [cosmosdb\_id](#output\_cosmosdb\_id) | CosmosDB Account Id |
| <a name="output_mongo_api_id"></a> [mongo\_api\_id](#output\_mongo\_api\_id) | The Cosmos DB Mongo Database Id |
| <a name="output_primary_master_key"></a> [primary\_master\_key](#output\_primary\_master\_key) | The Primary master key for the CosmosDB Account |
| <a name="output_secondary_master_key"></a> [secondary\_master\_key](#output\_secondary\_master\_key) | The Secondary master key for the CosmosDB Account |
| <a name="output_table_api_id"></a> [table\_api\_id](#output\_table\_api\_id) | The Cosmos DB Table Id |
<!-- END_TF_DOCS -->