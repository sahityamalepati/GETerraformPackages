locals {
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  loganalytics_state_exists  = length(values(data.terraform_remote_state.loganalytics.outputs)) == 0 ? false : true
  vmss_state_exists          = length(values(data.terraform_remote_state.virtualmachinescaleset.outputs)) == 0 ? false : true
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
# - Storage Account SAS for diagnostic logs
# - 
data "azurerm_storage_account_sas" "diagnostics_storage_account_sas" {
  count             = (var.diagnostics_sa_name != null && var.enable_storage_extension == true) ? 1 : 0
  connection_string = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_connection_strings_map, var.diagnostics_sa_name) : data.azurerm_storage_account.this.0.primary_connection_string
  https_only        = true

  resource_types {
    service   = false
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = true
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "8760h")

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }
}

# -
# - Storage Account Data Source for custom script extension
# - 
data "azurerm_storage_account" "custom_script_storage_account" {
  provider            = azurerm.ado
  for_each            = local.vmss_custom_script_storage_accounts
  name                = each.value.storage_account_name
  resource_group_name = each.value.resource_group_name
}

locals {
  diagnostics_storage_config_parms = {
    storage_account  = var.diagnostics_sa_name
    log_level_config = "LOG_DEBUG"
  }

  vmss_custom_script_list = flatten([
    for k, v in var.virtual_machine_scaleset_extensions : [
      for script in coalesce(v.custom_scripts, []) : {
        key                           = "${k}_${script.name}"
        name                          = script.name
        command_to_execute            = script.command_to_execute
        script_path                   = script.script_path
        script_args                   = script.script_path != null ? coalesce(script.script_args, {}) : null
        file_uris                     = script.file_uris
        storage_account_name          = script.storage_account_name
        resource_group_name           = script.resource_group_name
        virtual_machine_scaleset_name = v.virtual_machine_scaleset_name
        virtual_machine_scaleset_key  = k
      }
    ]
  ])

  vmss_custom_scripts = {
    for script in local.vmss_custom_script_list :
    script.key => script if script != null
  }

  vmss_custom_script_storage_accounts = {
    for script_k, script_v in local.vmss_custom_scripts :
    script_k => {
      storage_account_name = script_v.storage_account_name
      resource_group_name  = script_v.resource_group_name
    } if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }

  vmss_file_custom_scripts = {
    for script_k, script_v in local.vmss_custom_scripts :
    script_k => script_v if((script_v.command_to_execute != null || script_v.script_path != null) && script_v.storage_account_name == null)
  }

  vmss_blob_custom_scripts = {
    for script_k, script_v in local.vmss_custom_scripts :
    script_k => script_v if(script_v.storage_account_name != null && script_v.resource_group_name != null && script_v.file_uris != null && script_v.command_to_execute != null)
  }
}

# -
# - Custom Script with Azure Linux VM Scalesets
# -
resource "azurerm_virtual_machine_scale_set_extension" "custom_script" {
  for_each                     = local.vmss_file_custom_scripts
  name                         = each.value.name
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.value.virtual_machine_scaleset_key)["id"]
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"
  auto_upgrade_minor_version   = true

  settings = <<SETTINGS
    {
      "commandToExecute": "${each.value.script_path == null ? coalesce(each.value.command_to_execute, "") : ""}",
      "script": "${(each.value.command_to_execute == null && each.value.script_path != null) ? (base64encode(templatefile("${path.root}${each.value.script_path}", "${each.value.script_args}"))) : ""}"
    }
  SETTINGS  

  depends_on = [azurerm_virtual_machine_scale_set_extension.network_watcher]
}

# -
# - Custom Script from Blob with Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "blob_custom_script" {
  for_each                     = local.vmss_blob_custom_scripts
  name                         = each.value.name
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.value.virtual_machine_scaleset_key)["id"]
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.1"
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

  depends_on = [azurerm_virtual_machine_scale_set_extension.network_watcher]
}

# -
# - Enable Storage Diagnostics and Logs on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "storage" {
  for_each                     = (var.enable_storage_extension == true && var.diagnostics_sa_name != null) ? var.virtual_machine_scaleset_extensions : {}
  name                         = "storage-diagnostics"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.Azure.Diagnostics"
  type                         = "LinuxDiagnostic"
  type_handler_version         = "3.0"
  auto_upgrade_minor_version   = true

  settings = each.value.diagnostics_storage_config_path == null ? templatefile("${path.module}/Diagnostics/config.json", merge({ vm_id = (local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]) }, local.diagnostics_storage_config_parms)) : templatefile("${path.root}${each.value.diagnostics_storage_config_path}", merge({ vm_id = (local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]) }, local.diagnostics_storage_config_parms))

  protected_settings = <<SETTINGS
    {
      "storageAccountName": "${var.diagnostics_sa_name}",
      "storageAccountSasToken": "${data.azurerm_storage_account_sas.diagnostics_storage_account_sas.0.sas}",
      "storageAccountEndPoint": "https://core.windows.net/",
      "sinksConfig": {
        "sink": [
          {
              "name": "SyslogJsonBlob",
              "type": "JsonBlob"
          },
          {
              "name": "LinuxCpuJsonBlob",
              "type": "JsonBlob"
          }
        ]
      }
    }
  SETTINGS
}

# -
# - Enable Log Analytics Diagnostics and Logs on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "log_analytics" {
  for_each                     = var.enable_log_analytics_extension == true ? var.virtual_machine_scaleset_extensions : {}
  name                         = "log-analytics"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.EnterpriseCloud.Monitoring"
  type                         = "OmsAgentForLinux"
  type_handler_version         = "1.13"

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

# -
# - Enabling Azure Monitor Dependency virtual machine extension for Azure VMSS 
# -
resource "azurerm_virtual_machine_scale_set_extension" "vm_insights" {
  for_each                     = var.enable_log_analytics_extension == true ? var.virtual_machine_scaleset_extensions : {}
  name                         = "vm-insights"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                         = "DependencyAgentLinux"
  type_handler_version         = "9.5"
  auto_upgrade_minor_version   = true
  depends_on                   = [azurerm_virtual_machine_scale_set_extension.log_analytics]
}

# -
# - Enabling Network Watcher extension on Azure Linux VM Scaleset
# -
resource "azurerm_virtual_machine_scale_set_extension" "network_watcher" {
  for_each                     = var.enable_network_watcher_extension == true ? var.virtual_machine_scaleset_extensions : {}
  name                         = "network-watcher"
  virtual_machine_scale_set_id = local.vmss_state_exists == true ? lookup(data.terraform_remote_state.virtualmachinescaleset.outputs.vmss_id_map, each.value.virtual_machine_scaleset_name) : lookup(data.azurerm_virtual_machine_scale_set.this, each.key)["id"]
  publisher                    = "Microsoft.Azure.NetworkWatcher"
  type                         = "NetworkWatcherAgentLinux"
  type_handler_version         = "1.4"
  auto_upgrade_minor_version   = true
  depends_on                   = [azurerm_virtual_machine_scale_set_extension.vm_insights]
}
