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
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) |
| [azurerm_role_definition.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_definition) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ackey"></a> [ackey](#input\_ackey) | Not required if MSI is used to authenticate to the SA where state file is | `any` | `null` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | Map of roles assignments. | <pre>map(object({<br>    scope                = string<br>    role_definition_name = string<br>    principal_id         = string<br>  }))</pre> | `{}` | no |
| <a name="input_role_definitions"></a> [role\_definitions](#input\_role\_definitions) | Map of roles definitions. | <pre>map(object({<br>    name              = string<br>    description       = string<br>    scope             = string<br>    actions           = list(string)<br>    not_actions       = list(string)<br>    assignable_scopes = list(string)<br>  }))</pre> | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rold_definition_ids_map"></a> [rold\_definition\_ids\_map](#output\_rold\_definition\_ids\_map) | The Map of the Role Definition IDs. |
| <a name="output_role_assignment_ids_map"></a> [role\_assignment\_ids\_map](#output\_role\_assignment\_ids\_map) | The Map of the Role Assignment IDs. |
<!-- END_TF_DOCS -->