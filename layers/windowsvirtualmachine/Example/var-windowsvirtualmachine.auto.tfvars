resource_group_name = "[__resoure_group_name__]"

windows_vms = {
  vm1 = {
    name                                 = "jstartwinvm001"
    computer_name                        = "JSTARTWINVM001" #hostname has to be in uppercase letters
    vm_size                              = "Standard_DS1_v2"
    assign_identity                      = true
    availability_set_key                 = null
    vm_nic_keys                          = ["nic1"]
    zone                                 = "1"
    source_image_reference_offer         = "WindowsServer"          # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher     = "MicrosoftWindowsServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku           = "2016-Datacenter"        # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version       = "latest"                 # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    os_disk_name                         = "osdiskwin120920"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = null
    write_accelerator_enabled            = null
    recovery_services_vault_name         = null #"tfex-recovery-vault"
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    use_existing_disk_encryption_set     = false
    existing_disk_encryption_set_name    = null
    existing_disk_encryption_set_rg_name = null
    customer_managed_key_name            = null
    disk_encryption_set_name             = null
    enable_cmk_disk_encryption           = true # set it to true if you want to enable disk encryption using customer managed key
    enable_automatic_updates             = true
    custom_data_path                     = "//drivesetup.ps1"     #"//script_file.ps1" # Optional
    custom_data_args                     = { region = "eastus2" } #"{ name = "VMandVM", destination = "EASTUS2", version = "1.0" }    
  },
  vm2 = {
    name                                 = "jstartwinvm002"
    computer_name                        = "JSTARTWINVM002" #hostname has to be in uppercase letters
    vm_size                              = "Standard_D8s_v3"
    assign_identity                      = true
    availability_set_key                 = null
    vm_nic_keys                          = ["nic2"]
    zone                                 = "1"
    source_image_reference_offer         = "WindowsServer"          # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher     = "MicrosoftWindowsServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku           = "2016-Datacenter"        # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version       = "latest"                 # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    os_disk_name                         = "osdiskwin2120920"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = "128"
    write_accelerator_enabled            = null
    recovery_services_vault_name         = null #"tfex-recovery-vault"
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    use_existing_disk_encryption_set     = false
    existing_disk_encryption_set_name    = null
    existing_disk_encryption_set_rg_name = null
    customer_managed_key_name            = null
    disk_encryption_set_name             = null
    enable_cmk_disk_encryption           = true # set it to true if you want to enable disk encryption using customer managed key
    enable_automatic_updates             = true
    custom_data_path                     = "//drivesetup.ps1"     #"//script_file.ps1" # Optional
    custom_data_args                     = { region = "eastus2" } #"{ name = "VMandVM", destination = "EASTUS2", version = "1.0" }
  }
}

windows_vm_nics = {
  nic1 = {
    name                           = "jstartwinvm001-nic"
    subnet_name                    = "loadbalancer"
    vnet_name                      = null #"jstartvmfirst"
    networking_resource_group      = "[__networking_resoure_group_name__]"
    lb_backend_pool_names          = ["jstartvmlbbackend", "jstartvmlbbackendpublic"]
    lb_nat_rule_names              = null
    app_security_group_names       = ["asg-src-1"]
    app_gateway_backend_pool_names = ["appgateway-beap"]
    internal_dns_name_label        = null
    enable_ip_forwarding           = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking  = null # set it to true if you want to enable accelerated networking
    dns_servers                    = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "ip-config-internal"
      }
    ]
  },
  nic2 = {
    name                           = "jstartwinvm002-nic"
    subnet_name                    = "loadbalancer"
    vnet_name                      = null #"jstartvmfirst"
    networking_resource_group      = "[__networking_resoure_group_name__]"
    lb_backend_pool_names          = null
    lb_nat_rule_names              = null
    app_security_group_names       = null
    app_gateway_backend_pool_names = null
    internal_dns_name_label        = null
    enable_ip_forwarding           = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking  = null # set it to true if you want to enable accelerated networking
    dns_servers                    = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "ip-config-internal2"
      }
    ]
  }
}

administrator_user_name = "demo"
diagnostics_sa_name     = "jstartvmdev120920asa"
key_vault_name          = null #"jstartvmdev120920akv"

managed_data_disks = {
  "disk1" = {
    disk_name                 = "diskwinvm112092020"
    vm_key                    = "vm1"
    lun                       = 0
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk2" = {
    disk_name                 = "diskwinvm212092020"
    vm_key                    = "vm1"
    lun                       = 1
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk3" = {
    disk_name                 = "diskwinvm312092020"
    vm_key                    = "vm2"
    lun                       = 0
    storage_account_type      = "Standard_LRS"
    disk_size                 = "80"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk4" = {
    disk_name                 = "diskwinvm412092020"
    vm_key                    = "vm2"
    lun                       = 1
    storage_account_type      = "Standard_LRS"
    disk_size                 = "20"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk5" = {
    disk_name                 = "diskwinvm512092020"
    vm_key                    = "vm2"
    lun                       = 2
    storage_account_type      = "Standard_LRS"
    disk_size                 = "30"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk6" = {
    disk_name                 = "diskwinvm612092020"
    vm_key                    = "vm2"
    lun                       = 3
    storage_account_type      = "Standard_LRS"
    disk_size                 = "100"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk7" = {
    disk_name                 = "diskwinvm712092020"
    vm_key                    = "vm2"
    lun                       = 4
    storage_account_type      = "Standard_LRS"
    disk_size                 = "130"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk8" = {
    disk_name                 = "diskwinvm812092020"
    vm_key                    = "vm2"
    lun                       = 5
    storage_account_type      = "Standard_LRS"
    disk_size                 = "10"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk9" = {
    disk_name                 = "diskwinvm912092020"
    vm_key                    = "vm2"
    lun                       = 6
    storage_account_type      = "Standard_LRS"
    disk_size                 = "20"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk10" = {
    disk_name                 = "diskwinvm1012092020"
    vm_key                    = "vm2"
    lun                       = 7
    storage_account_type      = "Standard_LRS"
    disk_size                 = "20"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  }
}

vm_additional_tags = {
  iac            = "Terraform"
  env            = "uat"
  automated_by   = ""
  monitor_enable = true
}
