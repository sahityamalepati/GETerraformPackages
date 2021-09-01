resource_group_name = null #"jstart-vm-dev-110120"

enable_log_analytics_extension   = true
enable_storage_extension         = true
enable_network_watcher_extension = true

diagnostics_sa_name         = "jstartvmdev110120sa"
loganalytics_workspace_name = null #"jstartvmdev110120law"

virtual_machine_extensions = {
  extn1 = {
    virtual_machine_name            = "jstartvm01"
    diagnostics_storage_config_path = null # //Terraform//Diagnostics//Config.json" # Optional
    custom_scripts = [
      {
        name                 = "vmcustomextensionfirst"
        command_to_execute   = "ls"
        script_path          = null
        script_args          = null
        file_uris            = null
        storage_account_name = null
        resource_group_name  = null
      }
    ]
  }
}

ado_subscription_id = null # Change this to NPRD subscription where ADO RG resides when custom script SA is from ADO RG