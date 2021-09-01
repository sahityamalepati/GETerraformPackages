# Set the terraform backend
terraform {
  required_version = "~> 0.12.20"
  backend "azurerm" {} #Backend variables are initialized through the secret and variable folders
}

variable "subscription_id" {
  description = "Azure subscription Id."
}

variable "tenant_id" {
  description = "Azure tenant Id."
}

#variable "client_id" {
# description = "Azure service principal application Id"
#}

#variable "client_secret" {
#  description = "Azure service principal application Secret"
#}