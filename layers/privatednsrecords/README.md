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
| [azurerm_private_dns_a_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) |
| [azurerm_private_dns_cname_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) |
| [azurerm_private_dns_srv_record.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_srv_record) |
| [azurerm_private_endpoint_connection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_dns_a_records"></a> [dns\_a\_records](#input\_dns\_a\_records) | Map containing Private DNS A Records Objects | <pre>map(object({<br>    a_record_name         = string<br>    dns_zone_name         = string<br>    ttl                   = number<br>    ip_addresses          = list(string)<br>    private_endpoint_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_dns_cname_records"></a> [dns\_cname\_records](#input\_dns\_cname\_records) | Map containing Private DNS CNAME Records Objects | <pre>map(object({<br>    cname_record_name = string<br>    dns_zone_name     = string<br>    ttl               = number<br>    record            = string<br>  }))</pre> | `{}` | no |
| <a name="input_dns_records_additional_tags"></a> [dns\_records\_additional\_tags](#input\_dns\_records\_additional\_tags) | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| <a name="input_dns_srv_records"></a> [dns\_srv\_records](#input\_dns\_srv\_records) | Map containing Private DNS SRV Records Objects | <pre>map(object({<br>    srv_record_name = string<br>    dns_zone_name   = string<br>    ttl             = number<br>    records = list(object({<br>      priority = number<br>      weight   = number<br>      port     = number<br>      target   = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Specifies the Resource Group Name of Private DNS records. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_a_record_fqdn_map"></a> [dns\_a\_record\_fqdn\_map](#output\_dns\_a\_record\_fqdn\_map) | A Map of FQDN of the DNS A Records |
| <a name="output_dns_a_record_ids_map"></a> [dns\_a\_record\_ids\_map](#output\_dns\_a\_record\_ids\_map) | A Map of Id of the DNS A Records |
| <a name="output_dns_cname_record_fqdn_map"></a> [dns\_cname\_record\_fqdn\_map](#output\_dns\_cname\_record\_fqdn\_map) | A Map of FQDN of the DNS CNAME Records |
| <a name="output_dns_cname_record_ids_map"></a> [dns\_cname\_record\_ids\_map](#output\_dns\_cname\_record\_ids\_map) | A Map of Id of the DNS CNAME Records |
| <a name="output_dns_srv_record_fqdn_map"></a> [dns\_srv\_record\_fqdn\_map](#output\_dns\_srv\_record\_fqdn\_map) | A Map of FQDN of the DNS SRV Records |
| <a name="output_dns_srv_record_ids_map"></a> [dns\_srv\_record\_ids\_map](#output\_dns\_srv\_record\_ids\_map) | A Map of Id of the DNS SRV Records |
<!-- END_TF_DOCS -->