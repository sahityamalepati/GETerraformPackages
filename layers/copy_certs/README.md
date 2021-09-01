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
| [null_resource.this](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `string` | n/a | yes |
| <a name="input_source_vault"></a> [source\_vault](#input\_source\_vault) | Source Vault | `string` | n/a | yes |
| <a name="input_destination_vault"></a> [destination\_vault](#input\_destination\_vault) | Destination Vault | `string` | n/a | yes |
| <a name="input_cert_names"></a> [cert\_names](#input\_cert\_names) | Cert Names | list(string) | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|

<!-- END_TF_DOCS -->
