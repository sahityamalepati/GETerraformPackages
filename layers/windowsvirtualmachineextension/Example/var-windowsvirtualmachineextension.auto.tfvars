resource_group_name = null #"jumpstart-windows-vm-eastus2"

enable_log_analytics_extension = true
enable_storage_extension       = true

diagnostics_sa_name         = "jstartvmdev103820asa"
loganalytics_workspace_name = null #"jstartvmdev103820law"

virtual_machine_extensions = {
  extn1 = {
    virtual_machine_name            = "jstartwinvm001"
    diagnostics_storage_config_path = null
    run_command_script_path         = "//pagefile.ps1"
    run_command_script_args         = null
    custom_scripts                  = null
  },
  extn2 = {
    virtual_machine_name            = "jstartwinvm002"
    diagnostics_storage_config_path = null
    run_command_script_path         = "//pagefile.ps1"
    run_command_script_args         = null
    custom_scripts                  = null
  }
}

ado_subscription_id = null # Change this to NPRD subscription where ADO RG resides when custom script SA is from ADO RG