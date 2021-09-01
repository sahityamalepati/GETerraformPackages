resource_group_name = null #"[__resoure_group_name__]"

enable_log_analytics_extension = true
enable_storage_extension       = true

diagnostics_sa_name         = "jstartvmssdev112720asa"
loganalytics_workspace_name = null #"jstartvmssdev112720law"

virtual_machine_scaleset_extensions = {
  extn1 = {
    virtual_machine_scaleset_name   = "jstartwinvmss001"
    diagnostics_storage_config_path = null # "//Config.json" # Optional
    run_command_script_path         = null # "//script.ps1"
    run_command_script_args         = null
    domain_join = {
      dsc_endpoint = "https://99879e51-e537-4d38-93c6-88ac34e75b46.agentsvc.eus2.azure-automation.net/accounts/99879e51-e537-4d38-93c6-88ac34e75b46"
      dsc_key      = "[__dsc_registration_key__]"
      dsc_config   = "DSCPostConfig.localhost"
    }
    custom_scripts = [{
      name                 = "show-directories"
      command_to_execute   = "powershell.exe dir"
      file_uris            = null
      storage_account_name = null
      resource_group_name  = null
    }]
  }
}

ado_subscription_id = null # Change this to NPRD subscription where ADO RG resides when custom script SA is from ADO RG