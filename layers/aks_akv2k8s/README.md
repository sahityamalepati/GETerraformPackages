<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.24 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 1.2.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 1.2.4 |

## Modules

No modules.

## Resources

| Name |
|------|
| [helm_release.azure-key-vault-controller](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [helm_release.azure-key-vault-env-injector](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_identity_selector"></a> [identity\_selector](#input\_identity\_selector) | the selector from the identity binding | `string` | `"akv2k8s-identity"` | no |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | the namespace used to store the helm state secret object and the charts resources | `string` | `"extensions"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_vault_controller_version"></a> [vault\_controller\_version](#input\_vault\_controller\_version) | the version of akv2k8s vault controller | `string` | `"1.1.2"` | no |
| <a name="input_vault_env_injector_version"></a> [vault\_env\_injector\_version](#input\_vault\_env\_injector\_version) | the version of akv2k8s vault env injector | `string` | `"1.1.9"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->