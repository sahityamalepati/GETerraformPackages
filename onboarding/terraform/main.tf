data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}

data "azurerm_storage_account" "sa" {
  name                = "${var.appid}devopsstdgge"
  resource_group_name = "${local.common_vars.name_prefix}-devops-rg"
}

data "azurerm_virtual_network" "base_vnet" {
  name = var.vnet_name
  resource_group_name = var.vnet_rg_name
}

data "azurerm_subnet" "agent_subnet" {
  name = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.base_vnet.name
  resource_group_name = data.azurerm_virtual_network.base_vnet.resource_group_name
}

# Deploys the ACR
module acr {
  source              = "./Modules/ContainerRegistry"
  module_features     = var.deploy_acr
  acr_name            = "${var.appid}devopsacr"
  acr_rg_name         = "${local.common_vars.name_prefix}-devops-rg"
  acr_rg_region       = var.region
  acr_sku             = var.acr_sku
  acr_admin_enabled   = var.acr_admin_enabled
  tags                = local.common_tags
}

# Deploys the SIG
module sig {
  source               = "./Modules/SharedImageGallery"
  common_vars          = local.common_vars
  rg_name              = "${local.common_vars.name_prefix}-devops-rg"
  shared_image_gallery = local.shared_image_galleries
}

# Use to get the tenant ID of the Azure AD that will validate requests to the keyvault
data "azurerm_client_config" "current" {}

# Deploys the key vault
resource "azurerm_key_vault" "keyvault" {
  name                = "devops-kv-${var.appid}"
  resource_group_name = "${local.common_vars.name_prefix}-devops-rg"
  location            = var.region
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = local.common_tags

  soft_delete_enabled      = true
  purge_protection_enabled = true

  sku_name = "standard"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"
  }
}

# Get ADO Configuration cloudinit file. This can be converted to use an image.
data "template_file" "cloudinit" {
  for_each = local.vmss_agent_pools

  template = file("${path.module}/ado-agent-scripts/cloudinit.tpl")

  vars = {
    region     = var.region
    username   = var.vm_admin_username
    pool_name  = each.value["pool_name"]
  }
}

data "template_cloudinit_config" "config" {
  for_each      = local.vmss_agent_pools
  gzip          = true
  base64_encode = true

  part {
    content = data.template_file.cloudinit[each.key].rendered
  }
}

# VMSS for Azure DevOps Agents

module linux_vmss {
  source              = "./Modules/LinuxVirtualMachineScaleSet"
  vmss_agent_pools    = local.vmss_agent_pools
  common_vars         = local.common_vars
  azdo_settings       = local.azdo_settings
  storage_account_uri = data.azurerm_storage_account.sa.primary_blob_endpoint
  cloudinit_config    = data.template_cloudinit_config.config
  subnet_id          = data.azurerm_subnet.agent_subnet.id
}

# Setup Key Vault Diagnostic Logging - Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage" {
  name               = "storage-diagnostics"
  target_resource_id = azurerm_key_vault.keyvault.id
  storage_account_id = data.azurerm_storage_account.sa.id

  log {
    category = "AuditEvent"

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
    }
  }

  lifecycle {
    ignore_changes = [metric, log, target_resource_id]
  }
}


# VMSS MSI access to Storage Account
resource "azurerm_role_assignment" "vmss_to_storage_account_access" {
  scope                = data.azurerm_storage_account.sa.id
  role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = module.linux_vmss.identity.0.principal_id
}
