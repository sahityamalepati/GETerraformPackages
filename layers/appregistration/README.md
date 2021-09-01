<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | =1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | =1.0.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [azuread_application.this](https://registry.terraform.io/providers/hashicorp/azuread/1.0.0/docs/resources/application) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_names"></a> [application\_names](#input\_application\_names) | n/a | <pre>map(object({<br>        name                        = string<br>        available_to_other_tenants  = bool<br>        oauth2_allow_implicit_flow  = bool<br>    }))</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id_map"></a> [application\_id\_map](#output\_application\_id\_map) | n/a |
<!-- END_TF_DOCS -->