# data.terraform_remote_state.aks.outputs.aks

resource "helm_release" "ingress_nginx" {
  name       = var.release_name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version = "2.15.0"

  namespace = var.namespace_name

  set {
    name = "controller.ingressClass"
    value = var.ingress_class
  }

  set {
    name  = "controller.replicaCount"
    value = 2
  }

  set {
    name  = "controller.autoscaling.enabled"
    value = "true"
  }

  set {
    name  = "controller.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }

  set {
    name  = "controller.podAnnotations.linkerd\\.io/inject"
    value = "enabled"
  }

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = var.use_internal_load_balancer
    type  = "string"
  }

  set {
    name  = "defaultBackend.nodeSelector.beta\\.kubernetes\\.io/os"
    value = "linux"
  }
}
