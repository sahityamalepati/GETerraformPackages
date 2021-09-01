# --------------------------------------------------------
# Setup
# --------------------------------------------------------

# Provider block -> please make sure you have added partner id
provider "azurerm" {
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  #client_id       = var.client_id
  #client_secret   = var.client_secret
  partner_id      = "a79fe048-6869-45ac-8683-7fd2446fc73c"

  features {}
}

# Azure AD Provider
provider "azuread" {
  subscription_id = var.subscription_id
  #client_id       = var.client_id
  #client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Set the terraform backend
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.72.0"
    }
  }
  required_version = "~> 1.0.3"
  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}
