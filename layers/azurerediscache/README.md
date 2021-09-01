<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 0.12.20 |
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
| [azurerm_redis_cache.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache) |
| [azurerm_redis_firewall_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_firewall_rule) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of Azure Redis Cache firewall rule specification | <pre>list(object({<br>    name             = string # (Required) Specifies the name of the Firewall Rule.<br>    start_ip_address = string # (Required) The starting IP Address to allow through the firewall for this rule<br>    end_ip_address   = string # (Required) The ending IP Address to allow through the firewall for this rule<br>    redis_cache_key  = string # (Reuiqred) The redis cache instance this rule will be associated to.<br>  }))</pre> | `[]` | no |
| <a name="input_redis_cache_additional_tags"></a> [redis\_cache\_additional\_tags](#input\_redis\_cache\_additional\_tags) | Tags of the Azure Redis Cache in addition to the resource group tag. | `map(string)` | `{}` | no |
| <a name="input_redis_cache_instances"></a> [redis\_cache\_instances](#input\_redis\_cache\_instances) | Map of azure redis cache instances which needs to be created in a resource group | <pre>map(object({<br>    name                      = string<br>    capacity                  = number<br>    sku                       = string<br>    enable_non_ssl_port       = bool<br>    minimum_tls_version       = string<br>    subnet_name               = string<br>    vnet_name                 = string<br>    networking_resource_group = string<br>    shard_count               = number<br>    static_ip                 = string<br>    patch_schedules = list(object({<br>      day_of_week    = string<br>      start_hour_utc = number<br>    }))<br>    redis_configuration = object({<br>      enable_authentication           = bool<br>      maxmemory_reserved              = number<br>      maxmemory_delta                 = number<br>      maxmemory_policy                = string<br>      maxfragmentationmemory_reserved = number<br>      rdb_backup_enabled              = bool<br>      rdb_backup_frequency            = number<br>      rdb_backup_max_snapshot_count   = number<br>      backup_storage_account_name     = string<br>    })<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Azure Redis Cache. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_redis_cache_connection_strings_map"></a> [redis\_cache\_connection\_strings\_map](#output\_redis\_cache\_connection\_strings\_map) | n/a |
| <a name="output_redis_cache_hostnames_map"></a> [redis\_cache\_hostnames\_map](#output\_redis\_cache\_hostnames\_map) | n/a |
| <a name="output_redis_cache_ids_map"></a> [redis\_cache\_ids\_map](#output\_redis\_cache\_ids\_map) | n/a |
<!-- END_TF_DOCS -->