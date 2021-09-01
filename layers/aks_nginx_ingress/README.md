<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.24 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 1.2.4 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 1.2.4 |

## Modules

No modules.

## Resources

| Name |
|------|
| [helm_release.ingress_nginx](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_class"></a> [ingress\_class](#input\_ingress\_class) | name of the ingress class to route through this controller. | `string` | `"nginx"` | no |
| <a name="input_namespace_name"></a> [namespace\_name](#input\_namespace\_name) | the namespace used to store the helm state secret object and the charts resources | `string` | `"default"` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | name of the helm release | `string` | `"nginx-ingress-controller"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_use_internal_load_balancer"></a> [use\_internal\_load\_balancer](#input\_use\_internal\_load\_balancer) | When true an internal load balancer will be created | `bool` | `true` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->