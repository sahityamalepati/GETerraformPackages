# Helm provider for deployment of some modules (Linkerd, etc)

provider "helm" {
  #alias = "aks1"
  kubernetes {
    load_config_file       = "false"
    #host                   = module.Kubernetes.aks["aks1"].kube_admin_config[0].host
    host                   = data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].host
    username               = data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].username
    password               = data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].password
    #client_certificate     = base64decode(module.Kubernetes.aks["aks1"].kube_admin_config[0].client_certificate)
    client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].client_certificate)
    client_key             = base64decode(data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.aks["aks1"].kube_admin_config[0].cluster_ca_certificate)
    }
}

terraform {
  required_version = ">= 0.12.24"
  backend "azurerm" {}
  required_providers {

    helm = {
      # source  = "hashicorp/helm"
      version = ">= 1.2.4"
    }

    tls = {
      # source  = "hashicorp/tls"
      version = ">= 2.2.0"
    }
  }
}

