resource_group_name = null #"jumpstart-windows-vm-eastus2"

custom_script_extensions = {
  extn1 = {
    name                 = "changedriveletter"
    virtual_machine_name = "jstartwinvm001"
    command_to_execute   = "rename c:\\azuredata\\customdata.bin customdata.ps1 && powershell -file c:\\azuredata\\customdata.ps1"
  },
  extn2 = {
    name                 = "changedriveletter"
    virtual_machine_name = "jstartwinvm002"
    command_to_execute   = "rename c:\\azuredata\\customdata.bin customdata.ps1 && powershell -file c:\\azuredata\\customdata.ps1"
  }
}
