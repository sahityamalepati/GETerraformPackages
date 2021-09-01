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
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_traffic_manager_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_endpoint) |
| [azurerm_traffic_manager_profile.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/traffic_manager_profile) |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group in which to create the Traffic Manager resource | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_traffic_manager_additional_tags"></a> [traffic\_manager\_additional\_tags](#input\_traffic\_manager\_additional\_tags) | Tags of the Traffic Manager in addition to the resource group tag. | `map(string)` | `{}` | no |
| <a name="input_traffic_manager_endpoints"></a> [traffic\_manager\_endpoints](#input\_traffic\_manager\_endpoints) | Map of traffic manager endpoints which needs to be created in a resource group | <pre>map(object({<br>    name                          = string<br>    profile_key                   = string<br>    profile_status                = string<br>    type                          = string<br>    target                        = string<br>    target_resource_endpoint_name = string<br>    weight                        = number<br>    priority                       = string<br>    endpoint_location             = string<br>    custom_headers = list(object({<br>      name  = string<br>      value = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_traffic_manager_profiles"></a> [traffic\_manager\_profiles](#input\_traffic\_manager\_profiles) | Map of traffic manager profiles which needs to be created in a resource group | <pre>map(object({<br>    name                         = string<br>    routing_method               = string<br>    profile_status               = string<br>    relative_domain_name         = string<br>    ttl                          = number<br>    protocol                     = string<br>    port                         = number<br>    path                         = string<br>    interval_in_seconds          = number<br>    timeout_in_seconds           = number<br>    tolerated_number_of_failures = number<br>    expected_status_code_ranges  = list(string)<br>    custom_headers = list(object({<br>      name  = string<br>      value = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_traffic_manager_endpoints"></a> [traffic\_manager\_endpoints](#output\_traffic\_manager\_endpoints) | n/a |
| <a name="output_traffic_manager_profiles_map"></a> [traffic\_manager\_profiles\_map](#output\_traffic\_manager\_profiles\_map) | n/a |
<!-- END_TF_DOCS -->