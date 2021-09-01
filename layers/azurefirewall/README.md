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
| [azurerm_firewall.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall) |
| [azurerm_firewall_application_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_application_rule_collection) |
| [azurerm_firewall_nat_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_nat_rule_collection) |
| [azurerm_firewall_network_rule_collection.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_network_rule_collection) |
| [azurerm_public_ip.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) |
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_firewall_additional_tags"></a> [firewall\_additional\_tags](#input\_firewall\_additional\_tags) | Additional tags for the Azure Firewall resources, in addition to the resource group tags. | `map(string)` | `{}` | no |
| <a name="input_firewalls"></a> [firewalls](#input\_firewalls) | The Azure Firewalls with their properties. | <pre>map(object({<br>    name              = string<br>    threat_intel_mode = string<br>    ip_configurations = list(object({<br>      name                      = string<br>      subnet_name               = string<br>      vnet_name                 = string<br>      networking_resource_group = string<br>    }))<br>    public_ip_name = string<br>  }))</pre> | `{}` | no |
| <a name="input_fw_application_rules"></a> [fw\_application\_rules](#input\_fw\_application\_rules) | The Azure Firewall Application Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    action       = string<br>    rules = list(object({<br>      name             = string<br>      description      = string<br>      source_addresses = list(string)<br>      fqdn_tags        = list(string)<br>      target_fqdns     = list(string)<br>      protocol = list(object({<br>        port = number<br>        type = string<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_fw_nat_rules"></a> [fw\_nat\_rules](#input\_fw\_nat\_rules) | The Azure Firewall Nat Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    rules = list(object({<br>      name               = string<br>      description        = string<br>      source_addresses   = list(string)<br>      destination_ports  = list(string)<br>      protocols          = list(string)<br>      translated_address = string<br>      translated_port    = number<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_fw_network_rules"></a> [fw\_network\_rules](#input\_fw\_network\_rules) | The Azure Firewall Rules with their properties. | <pre>map(object({<br>    name         = string<br>    firewall_key = string<br>    priority     = number<br>    action       = string<br>    rules = list(object({<br>      name                  = string<br>      description           = string<br>      source_addresses      = list(string)<br>      destination_ports     = list(string)<br>      destination_addresses = list(string)<br>      protocols             = list(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group in which Firewall needs to be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_firewall_ids"></a> [firewall\_ids](#output\_firewall\_ids) | n/a |
| <a name="output_firewall_ips_map"></a> [firewall\_ips\_map](#output\_firewall\_ips\_map) | n/a |
| <a name="output_firewall_names"></a> [firewall\_names](#output\_firewall\_names) | n/a |
| <a name="output_firewall_private_ips"></a> [firewall\_private\_ips](#output\_firewall\_private\_ips) | n/a |
| <a name="output_firewall_public_ips"></a> [firewall\_public\_ips](#output\_firewall\_public\_ips) | n/a |
<!-- END_TF_DOCS -->