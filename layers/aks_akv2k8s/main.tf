# data.terraform_remote_state.aks.outputs.aks
resource "helm_release" "azure-key-vault-controller" {
  name       = "azure-key-vault-controller"
  repository = "http://charts.spvapi.no"
  chart      = "azure-key-vault-controller"
  version    =  var.vault_controller_version
  replace    = true
  create_namespace = true

  namespace = var.namespace_name

  set {
    name  = "image.pullPolicy"
    value = "Always"
  }
}

resource "helm_release" "azure-key-vault-env-injector" {
  name       = "azure-key-vault-env-injector"
  repository = "http://charts.spvapi.no"
  chart      = "azure-key-vault-env-injector"
  version    =  var.vault_env_injector_version
  namespace  = var.namespace_name

  set {
    name  = "installCrd"
    value = "false"
  }

  set {
    name  = "image.pullPolicy"
    value = "Always"
  }
}
