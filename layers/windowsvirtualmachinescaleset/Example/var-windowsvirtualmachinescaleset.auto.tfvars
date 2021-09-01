resource_group_name = "[___resource_group_name___]"

virtual_machine_scalesets = {
  vmss1 = {
    name                                   = "testwinvmss"
    computer_name_prefix                   = "VMSS"
    vm_size                                = "Standard_F4s_v2"
    zones                                  = ["1", "2"] # Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    assign_identity                        = true
    instances                              = 0
    subnet_name                            = "sn-ebs-scd6-dev"
    vnet_name                              = "277-gr-vnet"
    networking_resource_group              = "cs-connectedVNET-277"
    lb_backend_pool_names                  = null
    lb_nat_pool_names                      = null
    application_security_groups = [{
      name                                 = "dvueb-csss-ebs-miscdb-asg"
      resource_group                       = "dvueb-csss-nsg-rg"
    },
    {
      name                                 = "dvueb-csss-ebs-mapp-asg"
      resource_group                       = "dvueb-csss-nsg-rg"
    }]
    app_gateway_name                       = null
    lb_probe_name                          = null
    source_image_reference_offer           = null          # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher       = null # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku             = null        # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version         = null                 # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer                 
    storage_os_disk_caching                = "ReadWrite"
    managed_disk_type                      = "Premium_LRS"
    disk_size_gb                           = null
    write_accelerator_enabled              = null
    upgrade_mode                           = "Manual"
    enable_automatic_os_upgrade            = true
    rolling_upgrade_policy                 = null
    enable_cmk_disk_encryption             = false
    enable_accelerated_networking          = null
    enable_ip_forwarding                   = null
    enable_automatic_instance_repair       = false
    automatic_instance_repair_grace_period = null
    enable_default_auto_scale_settings     = false
    enable_automatic_updates               = true
    ultra_ssd_enabled                      = false
    custom_data_path                       = null #"//CustomData.tpl" #Optional
    custom_data_args                       = null #{ name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }    
    storage_profile_data_disks = [
      {
        lun                       = 0
        caching                   = "ReadWrite"
        disk_size_gb              = 32
        managed_disk_type         = "Premium_LRS"
        write_accelerator_enabled = null
      }
    ]
  }
}

custom_auto_scale_settings = {}

administrator_user_name = "gecloud"
diagnostics_sa_name   = "dvuebcsssbootdiagsa"
diagnostics_sa_rgname = "dvueb-csss-bootdiagsa-rg"
key_vault_name        = "dvueb-csss-ebs-kv1test"
key_vault_rgname      = "dvueb-csss-ebs-rg"

vmss_additional_tags = {
  iac            = "Terraform"
  env            = "uat"
  automated_by   = ""
  monitor_enable = true
}