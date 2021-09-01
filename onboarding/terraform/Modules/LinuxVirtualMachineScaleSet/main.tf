variable "vmss_agent_pools" {}
variable "storage_account_uri" {}
variable "common_vars" {}
variable "cloudinit_config" {}
variable "azdo_settings" {}
variable "subnet_id" {}

resource "tls_private_key" "ado" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "azurerm_linux_virtual_machine_scale_set" "ado" {
for_each = var.vmss_agent_pools
  name                  = "${var.common_vars.name_prefix}-${each.value["name"]}-vmss"
  location              = var.common_vars.region
  resource_group_name   = "${var.common_vars.name_prefix}-${each.value["resource_group_name"]}-rg"
  sku                   = each.value["sku"]
  tags                  = var.common_vars.tags

  instances             = each.value["instances"]
  upgrade_mode          = "Manual"
  overprovision         = false 

  computer_name_prefix  = "${var.common_vars.name_prefix}-${each.value["name"]}"
  admin_username = var.azdo_settings.admin_username
  admin_password = var.azdo_settings.admin_password
  disable_password_authentication = var.azdo_settings.admin_password == null ? true : false

  dynamic "admin_ssh_key" {
    for_each = var.azdo_settings.admin_password != null ? [] : [var.azdo_settings.admin_username]
    content {
      username   = var.azdo_settings.admin_username
      public_key = tls_private_key.ado.public_key_openssh
    }
  }

  # Cloud Init Config file
  custom_data = var.cloudinit_config["pool1"].rendered

  # if using a custom image specify source_image_id instead of source_image_reference
  # source_image_id = ""
  source_image_reference {
   publisher = "Canonical"
   offer     = "UbuntuServer"
   sku       = "18.04-LTS"
   version   = "latest"
  }

  os_disk {
    caching               = "ReadWrite"
    storage_account_type  = "Standard_LRS"
  }

  network_interface {
    name    = "${var.common_vars.name_prefix}-${each.value["name"]}-vmss-nic"
    primary = true

    ip_configuration {
      name      = "ipconfig1"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  identity {
    type = "SystemAssigned"
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  lifecycle {
    ignore_changes = [
      admin_ssh_key
    ]
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "waitForCloudInit" {
  name                            = "waitForCloudInit"
  virtual_machine_scale_set_id    = azurerm_linux_virtual_machine_scale_set.ado["pool1"].id
  publisher                       = "Microsoft.Azure.Extensions"
  type                            = "CustomScript"
  type_handler_version            = "2.0"

  settings = jsonencode({
    "commandToExecute" = "count=0 && while [ ! -f /cloudinitfinished.txt -a $count -lt 3600 ]; do sleep 1 && count=$(( $count + 1 )); done"
  })
}

output identity {
    value = azurerm_linux_virtual_machine_scale_set.ado["pool1"].identity
}