resource_group_name = null #"jstart-all-dev-10022020"

enable_log_analytics_extension   = true
enable_storage_extension         = true
enable_network_watcher_extension = true

diagnostics_sa_name         = "jstartall10022020sa"
loganalytics_workspace_name = null #"jstartall10022020law"

virtual_machine_scaleset_extensions = {
  extn1 = {
    virtual_machine_scaleset_name   = "jstartvmss001"
    diagnostics_storage_config_path = null # //Terraform//Diagnostics//Config.json" # Optional
    custom_scripts = [
      {
        name                 = "vmsscustomextensionfirst"
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