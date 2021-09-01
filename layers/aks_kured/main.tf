# data.terraform_remote_state.aks.outputs.aks

resource "helm_release" "kured" {
  name       = "kured2"
  repository = "https://weaveworks.github.io/kured"
  chart      = "kured"
  version = "2.2.0"
  # replace    = true
  # create_namespace = true 
  # force_update = true

  namespace        = var.namespace_name

  set {
    name  = "nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "tolerations[0].effect"
    value = "NoSchedule"
  }

  set {
    name  = "tolerations[0].key"
    value = "node-role\\.kubernetes\\.io/master"
  }

  set {
    name  = "tolerations[1].operator"
    value = "Exists"
  }

  set {
    name  = "tolerations[1].key"
    value = "CriticalAddonsOnly"
  }

  set {
    name  = "tolerations[2].operator"
    value = "Exists"
  }

  set {
    name  = "tolerations[2].effect"
    value = "NoExecute"
  }

  set {
    name  = "tolerations[3].operator"
    value = "Exists"
  }

  set {
    name  = "tolerations[3].effect"
    value = "NoSchedule"
  }
}
