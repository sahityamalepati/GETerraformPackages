# --------------------------------------------------------
# Setup
# --------------------------------------------------------

# Provider block -> please make sure you have added partner id
provider "azurerm" {
  # Whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "~> 2.20.0"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  partner_id      = "a79fe048-6869-45ac-8683-7fd2446fc73c"

  features {}
}

# Set the terraform backend
terraform {
  required_version = "~> 0.12.20"
  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}

# Provider block -> please make sure you have added partner id
# Provider to Non Production Environment
provider "azurerm" {
  # Whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  version         = "~> 2.20.0"
  alias           = "ado"
  tenant_id       = var.tenant_id
  subscription_id = var.ado_subscription_id == null ? var.subscription_id : var.ado_subscription_id
  partner_id      = "a79fe048-6869-45ac-8683-7fd2446fc73c"

  features {}
}