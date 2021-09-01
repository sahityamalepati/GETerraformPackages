provider "azurerm" {
  alias                       = "MSSMS_7310"
  version                     = "~> 2.6.0"
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id
  #client_id                   = var.client_id
  #client_secret               = var.client_secret
  skip_provider_registration  = true
  skip_credentials_validation = true
  features {}
}

provider random {
  version = "~> 2.2"
}

# Azure AD Provider
provider "azuread" {
  version = "0.8.0"
}

provider "azurerm" {
  alias                       = "shared_subscription"
  version                     = "~> 2.6.0"
  tenant_id                   = var.tenant_id
  subscription_id             = var.key_vault_subscription_id
  use_msi                     = true
  skip_provider_registration  = true
  skip_credentials_validation = true
  features {}
}
