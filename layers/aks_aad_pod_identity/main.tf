# data.terraform_remote_state.aks.outputs.aks

resource "helm_release" "aad_pod_identity" {
  name       = "aad-pod-identity"
  repository = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
  #repository = "aad-pod-identity"
  chart = "aad-pod-identity"

  namespace = var.namespace_name

  values = var.identities != null && length(var.identities) >= 1 ? [data.template_file.azureIdentities.rendered] : []

}

data "template_file" "azureIdentities" {
  template = <<EOF
azureIdentities:
%{for idnet in var.identities~}
  - name: ${idnet.name}
    namespace: ${idnet.namespace}
    type: 0
    resourceID: ${idnet.resource_id}
    clientID: ${idnet.client_id}
    binding:
      name: ${idnet.name}-binding
      selector: ${idnet.name}
%{endfor~}
EOF
}
