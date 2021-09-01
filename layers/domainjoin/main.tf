data "azurerm_resource_group" "this" {
  provider = azurerm.MSSMS_7310
  name     = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  provider            = azurerm.shared_subscription
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg_name
}

data "azurerm_key_vault_secret" "this" {
  provider     = azurerm.shared_subscription
  for_each     = var.domain_join_extensions
  key_vault_id = data.azurerm_key_vault.this.id
  name         = each.value.secret_name
}

data "azurerm_virtual_machine" "this" {
  provider            = azurerm.MSSMS_7310
  for_each            = var.domain_join_extensions
  name                = each.value.virtual_machine_name
  resource_group_name = data.azurerm_resource_group.this.name
}

locals {
  Name = {
    for dj_k, dj_v in var.domain_join_extensions :
    dj_k => split("@@@", data.azurerm_key_vault_secret.this[dj_k].value)[0]
  }
  OUPath = {
    for dj_k, dj_v in var.domain_join_extensions :
    dj_k => split("@@@", data.azurerm_key_vault_secret.this[dj_k].value)[1]
  }
  User = {
    for dj_k, dj_v in var.domain_join_extensions :
    dj_k => split("@@@", data.azurerm_key_vault_secret.this[dj_k].value)[2]
  }
  Password = {
    for dj_k, dj_v in var.domain_join_extensions :
    dj_k => split("@@@", data.azurerm_key_vault_secret.this[dj_k].value)[3]
  }
}

resource "azurerm_virtual_machine_extension" "this" {
  provider                   = azurerm.MSSMS_7310
  for_each                   = var.domain_join_extensions
  name                       = "join-domain"
  virtual_machine_id         = data.azurerm_virtual_machine.this[each.key].id
  publisher                  = "Microsoft.Compute"
  type                       = "JsonADDomainExtension"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = true

  # NOTE: the `OUPath` field is intentionally blank, to put it in the Computers OU
  settings = <<SETTINGS
    {
      "Name":  "${lookup(local.Name, each.key)}",
      "OUPath": "${lookup(local.OUPath, each.key)}",
      "User": "${lookup(local.User, each.key)}",
      "Restart": "true",
      "Options": "3"
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
      "Password": "${lookup(local.Password, each.key)}"
    }
  SETTINGS
}
