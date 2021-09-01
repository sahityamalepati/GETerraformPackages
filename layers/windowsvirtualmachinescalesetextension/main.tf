locals {
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  loganalytics_state_exists  = length(values(data.terraform_remote_state.loganalytics.outputs)) == 0 ? false : true
  vmss_state_exists          = length(values(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs)) == 0 ? false : true
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

data "azurerm_virtual_machine_scale_set" "this" {
  for_each            = local.vmss_state_exists == false ? var.virtual_machine_scaleset_extensions : {}
  name                = each.value.virtual_machine_scaleset_name
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
  for_each            = local.windows_vmss_custom_script_storage_accounts
  name                = each.value.storage_account_name
  resource_group_name = each.value.resource_group_name
}

locals {
  diagnostics_storage_config_parms = {
    storage_account = var.diagnostics_sa_name
  }

  windows_vmss_custom_script_list = flatten([
    for k, v in var.virtual_machine_scaleset_extensions : [
      for script in coalesce(v.custom_scripts, []) : {
        key                           = "${k}_${script.name}"
        name                          = script.name
        command_to_execute            = script.command_to_execute
        file_uris                     = script.file_uris
        storage_account_name          = script.storage_account_name
        resource_group_name           = script.resource_group_name
        virtual_machine_scaleset_name = v.virtual_machine_scaleset_name
        virtual_machine_scaleset_key  = k
      }
    ]
  ])

  windows_vmss_custom_scripts = {
    for script in local.windows_vmss_custom_script_list :
    script.key => script if script != null
  }

  windows_vmss_custom_script_storage_accounts = {
    for script_k, script_v in local.windows_vmss_custom_scripts :
    script_k => {
      storage_account_name = script_v.storage_account_name
      resource_group_name  = script_v.resource_group_name
    } if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }

  windows_vmss_file_custom_scripts = {
    for script_k, script_v in local.windows_vmss_custom_scripts :
    script_k => script_v if(script_v.command_to_execute != null && script_v.storage_account_name == null && script_v.resource_group_name == null && script_v.file_uris == null)
  }

  windows_vmss_blob_custom_scripts = {
    for script_k, script_v in local.windows_vmss_custom_scripts :
    script_k => script_v if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }

  run_command_scripts = {
    for k, v in var.virtual_machine_scaleset_extensions :
    k => v if(v.run_command_script_path != null)
  }

  domain_join_scripts = {
    for k, v in var.virtual_machine_scaleset_extensions :
    k => v if(v.domain_join != null)
  }
}

# -
# - Custom Script with Azure Windows VM Scalesets
# -
resource "azurerm_virtual_machine_scale_set_extension" "custom_script" {
  for_each                     = local.windows_vmss_file_custom_scripts
  name                         = each.value.name
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.value.virtual_machine_scaleset_key)["id"]
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.10"
  auto_upgrade_minor_version   = true

  settings = jsonencode({
    "commandToExecute" : each.value.command_to_execute
  })

  depends_on = [azurerm_virtual_machine_scale_set_extension.storage, azurerm_virtual_machine_scale_set_extension.log_analytics, azurerm_virtual_machine_scale_set_extension.run_command]
}

# -
# - Custom Script from Blob with Azure Windows VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "blob_custom_script" {
  for_each                     = local.windows_vmss_blob_custom_scripts
  name                         = each.value.name
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.value.virtual_machine_scaleset_key)["id"]
  publisher                    = "Microsoft.Compute"
  type                         = "CustomScriptExtension"
  type_handler_version         = "1.10"
  auto_upgrade_minor_version   = true

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

  depends_on = [azurerm_virtual_machine_scale_set_extension.storage, azurerm_virtual_machine_scale_set_extension.log_analytics, azurerm_virtual_machine_scale_set_extension.run_command]
}

# -
# - Enable Storage Diagnostics and Logs on Azure Windows VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "storage" {
  for_each                     = (var.enable_storage_extension == true && var.diagnostics_sa_name != null) ? var.virtual_machine_scaleset_extensions : {}
  name                         = "storage-diagnostics"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.Azure.Diagnostics"
  type                         = "IaaSDiagnostics"
  type_handler_version         = "1.5"
  auto_upgrade_minor_version   = true

  settings = each.value.diagnostics_storage_config_path == null ? templatefile("${path.module}/Diagnostics/config.json", merge({ vmss_id = (local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]) }, local.diagnostics_storage_config_parms)) : templatefile("${path.root}${each.value.diagnostics_storage_config_path}", merge({ vmss_id = (local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]) }, local.diagnostics_storage_config_parms))

  protected_settings = <<SETTINGS
    {
      "storageAccountName": "${var.diagnostics_sa_name}",
      "storageAccountKey": "${local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_access_keys_map, var.diagnostics_sa_name) : data.azurerm_storage_account.this.0.primary_access_key}",
      "storageAccountEndPoint": "https://core.windows.net/"
    }
  SETTINGS
}

# -
# - Enable Log Analytics Diagnostics and Logs on Azure Windows VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "log_analytics" {
  for_each                     = var.enable_log_analytics_extension == true ? var.virtual_machine_scaleset_extensions : {}
  name                         = "log-analytics"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "MicrosoftMonitoringAgent"
  type_handler_version         = "1.0"
  auto_upgrade_minor_version   = true

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

  depends_on = [azurerm_virtual_machine_scale_set_extension.storage]
}

# Enable Run Command Extension on Azure Windows VM Scaleset
resource "azurerm_virtual_machine_scale_set_extension" "run_command" {
  for_each                     = local.run_command_scripts
  name                         = "run-command"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.CPlat.Core"
  type                         = "RunCommandWindows"
  type_handler_version         = "1.1"
  auto_upgrade_minor_version   = true

  settings = jsonencode({
    script = split("\n", templatefile("${path.root}${each.value.run_command_script_path}", coalesce(each.value.run_command_script_args, {})))
  })

  depends_on = [azurerm_virtual_machine_scale_set_extension.storage, azurerm_virtual_machine_scale_set_extension.log_analytics]
}

resource "azurerm_virtual_machine_scale_set_extension" "domain_join" {
  for_each                     = local.domain_join_scripts
  name                         = "domain-join"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.windowsvirtualmachinescaleset.outputs.windows_vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.Powershell"
  type                         = "DSC"
  type_handler_version         = "2.80"
  auto_upgrade_minor_version   = true

  protected_settings = <<SETTINGS
    {
      "Items": {
        "registrationKeyPrivate" : "${each.value.domain_join.dsc_key}"
      }
    }
  SETTINGS

  settings = <<SETTINGS
    {
      "Properties": {
        "RegistrationKey": {
          "UserName": "PLACEHOLDER_DONOTUSE",
          "Password": "PrivateSettingsRef:registrationKeyPrivate"
        },
        "RegistrationUrl": "${each.value.domain_join.dsc_endpoint}",
        "NodeConfigurationName": "${each.value.domain_join.dsc_config}"        
      }    
    }
  SETTINGS

  depends_on = [azurerm_virtual_machine_scale_set_extension.storage, azurerm_virtual_machine_scale_set_extension.log_analytics]
}
