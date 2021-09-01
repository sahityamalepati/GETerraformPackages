locals {
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  loganalytics_state_exists  = length(values(data.terraform_remote_state.loganalytics.outputs)) == 0 ? false : true
  vm_state_exists            = length(values(data.terraform_remote_state.windowsvirtualmachine.outputs)) == 0 ? false : true
}

data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  count               = (local.storage_state_exists == false && var.diagnostics_sa_name != null && var.enable_storage_extension == true) ? 1 : 0
  name                = var.diagnostics_sa_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_virtual_machine" "this" {
  for_each            = local.vm_state_exists == false ? var.virtual_machine_extensions : {}
  name                = each.value.virtual_machine_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

data "azurerm_log_analytics_workspace" "this" {
  count               = (local.loganalytics_state_exists == false && var.loganalytics_workspace_name != null && var.enable_log_analytics_extension == true) ? 1 : 0
  name                = var.loganalytics_workspace_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

# -
# - Storage Account Data Source for custom script extension
# - 
data "azurerm_storage_account" "custom_script_storage_account" {
  provider            = azurerm.ado
  for_each            = local.windows_vm_custom_script_storage_accounts
  name                = each.value.storage_account_name
  resource_group_name = each.value.resource_group_name
}

locals {
  diagnostics_storage_config_parms = {
    storage_account = var.diagnostics_sa_name
  }

  windows_vm_custom_script_list = flatten([
    for k, v in var.virtual_machine_extensions : [
      for script in coalesce(v.custom_scripts, []) : {
        key                  = "${k}_${script.name}"
        name                 = script.name
        command_to_execute   = script.command_to_execute
        file_uris            = script.file_uris
        storage_account_name = script.storage_account_name
        resource_group_name  = script.resource_group_name
        virtual_machine_name = v.virtual_machine_name
        virtual_machine_key  = k
      }
    ]
  ])

  windows_vm_custom_scripts = {
    for script in local.windows_vm_custom_script_list :
    script.key => script if script != null
  }

  windows_vm_custom_script_storage_accounts = {
    for script_k, script_v in local.windows_vm_custom_scripts :
    script_k => {
      storage_account_name = script_v.storage_account_name
      resource_group_name  = script_v.resource_group_name
    } if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }

  windows_vm_file_custom_scripts = {
    for script_k, script_v in local.windows_vm_custom_scripts :
    script_k => script_v if(script_v.command_to_execute != null && script_v.storage_account_name == null && script_v.resource_group_name == null && script_v.file_uris == null)
  }

  windows_vm_blob_custom_scripts = {
    for script_k, script_v in local.windows_vm_custom_scripts :
    script_k => script_v if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }

  run_script_path = {
    for k, v in var.virtual_machine_extensions :
    k => v.run_command_script_path != null ? templatefile("${path.root}${v.run_command_script_path}", coalesce(v.run_command_script_args, {})) : templatefile("${path.module}/Scripts/DeletePageFiles.ps1", {})
  }
}

# -
# - Custom Script with Windows virtual machines
# -
resource "azurerm_virtual_machine_extension" "custom_script" {
  for_each                   = local.windows_vm_file_custom_scripts
  name                       = each.value.name
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.value.virtual_machine_key)["id"]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    "commandToExecute" : each.value.command_to_execute
  })

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)

  depends_on = [azurerm_virtual_machine_extension.storage, azurerm_virtual_machine_extension.log_analytics, azurerm_virtual_machine_extension.run_command]
}

# -
# - Custom Script from Blob with Windows virtual machines
# -
resource "azurerm_virtual_machine_extension" "blob_custom_script" {
  for_each                   = local.windows_vm_blob_custom_scripts
  name                       = each.value.name
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.value.virtual_machine_key)["id"]
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.10"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "commandToExecute": "${each.value.command_to_execute}",
      "fileUris": ["${join("\",\"", each.value.file_uris)}"]
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {      
      "storageAccountName": "${lookup(data.azurerm_storage_account.custom_script_storage_account, each.key)["name"]}",
      "storageAccountKey": "${lookup(data.azurerm_storage_account.custom_script_storage_account, each.key)["primary_access_key"]}"  
    }
  SETTINGS

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)

  depends_on = [azurerm_virtual_machine_extension.storage, azurerm_virtual_machine_extension.log_analytics, azurerm_virtual_machine_extension.run_command]
}

# -
# - Enable Storage Diagnostics and Logs on Azure Windows VM
# -
resource "azurerm_virtual_machine_extension" "storage" {
  for_each                   = (var.enable_storage_extension == true && var.diagnostics_sa_name != null) ? var.virtual_machine_extensions : {}
  name                       = "storage-diagnostics"
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]
  publisher                  = "Microsoft.Azure.Diagnostics"
  type                       = "IaaSDiagnostics"
  type_handler_version       = "1.5"
  auto_upgrade_minor_version = true

  settings = each.value.diagnostics_storage_config_path == null ? templatefile("${path.module}/Diagnostics/config.json", merge({ vm_id = (local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]) }, local.diagnostics_storage_config_parms)) : templatefile("${path.root}${each.value.diagnostics_storage_config_path}", merge({ vm_id = (local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]) }, local.diagnostics_storage_config_parms))

  protected_settings = <<SETTINGS
    {
      "storageAccountName": "${var.diagnostics_sa_name}",
      "storageAccountKey": "${local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_access_keys_map, var.diagnostics_sa_name) : data.azurerm_storage_account.this.0.primary_access_key}",
      "storageAccountEndPoint": "https://core.windows.net/"      
    }
  SETTINGS

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)
}

# -
# - Enable Log Analytics Diagnostics and Logs on Azure Windows VM
# -
resource "azurerm_virtual_machine_extension" "log_analytics" {
  for_each                   = var.enable_log_analytics_extension == true ? var.virtual_machine_extensions : {}
  name                       = "log-analytics"
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId": "${local.loganalytics_state_exists == true ? data.terraform_remote_state.loganalytics.outputs.law_workspace_id : data.azurerm_log_analytics_workspace.this.0.workspace_id}"     
    }
  SETTINGS

  protected_settings = <<SETTINGS
    {
      "workspaceKey": "${local.loganalytics_state_exists == true ? data.terraform_remote_state.loganalytics.outputs.law_key : data.azurerm_log_analytics_workspace.this.0.primary_shared_key}"
    }
  SETTINGS

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)

  depends_on = [azurerm_virtual_machine_extension.storage]
}

# Enable Run Command Extension on Azure Windows VM
resource "azurerm_virtual_machine_extension" "run_command" {
  for_each                   = var.virtual_machine_extensions
  name                       = each.value.run_command_script_path != null ? "run-command" : "delete-pagefiles-run-command"
  virtual_machine_id         = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_id_map, each.value.virtual_machine_name) : lookup(data.azurerm_virtual_machine.this, each.key)["id"]
  publisher                  = "Microsoft.CPlat.Core"
  type                       = "RunCommandWindows"
  type_handler_version       = "1.1"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    script = split("\n", lookup(local.run_script_path, each.key))
  })

  tags = local.vm_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachine.outputs.windows_vm_tags_map, each.value.virtual_machine_name) : (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags)

  depends_on = [azurerm_virtual_machine_extension.storage, azurerm_virtual_machine_extension.log_analytics]
}
