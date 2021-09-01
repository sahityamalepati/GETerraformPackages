resource_group_name = null #"jstart-all-dev-02012022"

enable_log_analytics_extension   = false
enable_storage_extension         = true
enable_network_watcher_extension = false

diagnostics_sa_name         = "jstartall02012022sa"
loganalytics_workspace_name = null #"jstartall02012022law"

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