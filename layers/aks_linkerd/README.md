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
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 2.2.0 |

## Modules

No modules.

## Resources

| Name |
|------|
| [helm_release.linkerd](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) |
| [tls_cert_request.issuer_req](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/cert_request) |
| [tls_locally_signed_cert.issuer_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/locally_signed_cert) |
| [tls_private_key.issuer_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |
| [tls_private_key.trustanchor_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) |
| [tls_self_signed_cert.trustanchor_cert](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_proxy_port_number"></a> [bastion\_proxy\_port\_number](#input\_bastion\_proxy\_port\_number) | Port number used by the bastion proxy | `string` | `"3128"` | no |
| <a name="input_identity_issuer_cert_validity_period_hours"></a> [identity\_issuer\_cert\_validity\_period\_hours](#input\_identity\_issuer\_cert\_validity\_period\_hours) | Number of hours the identity issuer is valid Default: 87600 (10 years) | `number` | `87600` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Azure subscription Id. | `any` | n/a | yes |
| <a name="input_tenant_id"></a> [tenant\_id](#input\_tenant\_id) | Azure tenant Id. | `any` | n/a | yes |
| <a name="input_trust_anchor_cert_validity_period_hours"></a> [trust\_anchor\_cert\_validity\_period\_hours](#input\_trust\_anchor\_cert\_validity\_period\_hours) | Number of hours the trust anchor is valid Default: 175200 (20 years) | `number` | `175200` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->