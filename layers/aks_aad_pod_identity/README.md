<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.24 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 1.2.4 |
| <a name="requirement_template"></a> [template](#requirement\_template) | >= 2.1.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 1.2.4 |
| <a name="provider_template"></a> [template](#provider\_template) | >= 2.1.2 |

## Modules

No modules.

## Resources

| Name |
|------|
| [helm_release.aad_pod_identity](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [template_file.azureIdentities](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_forceNameSpaced"></a> [forceNameSpaced](#input\_forceNameSpaced) | By default, AAD Pod Identity matches pods to identities across namespaces. To match only pods in the namespace containing AzureIdentity set this to true. | `bool` | `false` | no |
| <a name="input_identities"></a> [identities](#input\_identities) | a list if identities to create at deploy time | <pre>list(object({<br>    name        = string<br>    resource_id = string<br>    #client_id   = string<br>    namespace   = string<br>  }))</pre> | n/a | yes |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | the namespace used to store the helm state secret object and the charts resources | `string` | `"extensions"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_identities"></a> [identities](#output\_identities) | n/a |
<!-- END_TF_DOCS -->