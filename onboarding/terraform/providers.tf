provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

provider "time" {
}

# Set the terraform backend
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.43.0"
    }
    time = {
      version = ">= 0.6.0"
    }
  }
  backend "azurerm" {} # Backend variables are initialized through the secret and variable folders
}