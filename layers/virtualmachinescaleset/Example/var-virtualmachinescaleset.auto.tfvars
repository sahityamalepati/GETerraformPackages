resource_group_name = "[___resource_group_name___]"

virtual_machine_scalesets = {
  vm1 = {
    name                                   = "test-vmss"
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
    zones                                  = ["1", "2"] # Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    vm_size                                = "Standard_DS1_v2"
    enable_ip_forwarding                   = false
    assign_identity                        = true
    enable_rolling_upgrade                 = false
    enable_automatic_instance_repair       = false
    rolling_upgrade_policy                 = null
    automatic_instance_repair_grace_period = null
    instances                              = 1
    disable_password_authentication        = true
    source_image_reference_offer           = null #(Mandatory) 
    source_image_reference_publisher       = null    #(Mandatory) 
    source_image_reference_sku             = null    #(Mandatory) 
    source_image_reference_version         = null       #(Mandatory)    
    storage_os_disk_caching                = "ReadWrite"
    managed_disk_type                      = "Premium_LRS"
    disk_size_gb                           = 32
    write_accelerator_enabled              = null
    enable_default_auto_scale_settings     = false
    enable_accelerated_networking          = null
    enable_ip_forwarding                   = null
    enable_cmk_disk_encryption             = false
    use_existing_ssh_key                   = false #true           #set this to true if you want to use existing ssh key
    secret_name_of_public_ssh_key          = null #"publickeynew" #key vault secret name where existing public ssh key is stored
    custom_data_path                       = null #"//Terraform//Scripts//CustomData.tpl" #Optional
    custom_data_args                       = null #{ name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }    
    existing_disk_encryption_set_name      = null
    existing_disk_encryption_set_rg_name   = null
    use_existing_disk_encryption_set       = null
    single_placement_group                 = false
    storage_profile_data_disks = [
      {
        lun                                = 0
        caching                            = "ReadWrite"
        disk_size_gb                       = 32
        managed_disk_type                  = "Standard_LRS"
        write_accelerator_enabled          = null
      }
    ]
  },
  vm2 = {
    name                                   = "test-vmss1"
    subnet_name                            = "sn-ebs-scd6-dev"
    vnet_name                              = "277-gr-vnet"
    networking_resource_group              = "cs-connectedVNET-277"
    lb_backend_pool_names                  = null
    lb_nat_pool_names                      = null
    application_security_groups            = null
    app_gateway_name                       = null
    lb_probe_name                          = null
    zones                                  = ["1", "2"] # Availability Zone id, could be 1, 2 or 3, if you don't need to set it to null or delete the line if mutli zone is enabled with LB, LB has to be standard
    vm_size                                = "Standard_DS1_v2"
    enable_ip_forwarding                   = false
    assign_identity                        = true
    enable_rolling_upgrade                 = false
    enable_automatic_instance_repair       = false
    rolling_upgrade_policy                 = null
    automatic_instance_repair_grace_period = null
    instances                              = 1
    disable_password_authentication        = true
    source_image_reference_offer           = null #(Mandatory) 
    source_image_reference_publisher       = null    #(Mandatory) 
    source_image_reference_sku             = null    #(Mandatory) 
    source_image_reference_version         = null       #(Mandatory)    
    storage_os_disk_caching                = "ReadWrite"
    managed_disk_type                      = "Premium_LRS"
    disk_size_gb                           = 32
    write_accelerator_enabled              = null
    enable_default_auto_scale_settings     = false
    enable_accelerated_networking          = null
    enable_ip_forwarding                   = null
    enable_cmk_disk_encryption             = false
    use_existing_ssh_key                   = false #true           #set this to true if you want to use existing ssh key
    secret_name_of_public_ssh_key          = null #"publickeynew" #key vault secret name where existing public ssh key is stored
    custom_data_path                       = null #"//Terraform//Scripts//CustomData.tpl" #Optional
    custom_data_args                       = null #{ name = "VMandVMSS", destination = "EASTUS2", version = "1.0" }    
    existing_disk_encryption_set_name      = null
    existing_disk_encryption_set_rg_name   = null
    use_existing_disk_encryption_set       = null
    single_placement_group                 = false
    storage_profile_data_disks = [
      {
        lun                                = 0
        caching                            = "ReadWrite"
        disk_size_gb                       = 32
        managed_disk_type                  = "Standard_LRS"
        write_accelerator_enabled          = null
      }
    ]
  }
}

custom_auto_scale_settings = {}

administrator_user_name      = "gecloud"


diagnostics_sa_name   = "dvuebcsssbootdiagsa"
diagnostics_sa_rgname = "dvueb-csss-bootdiagsa-rg"
key_vault_name        = "dvueb-csss-ebs-kv1test"
key_vault_rgname      = "dvueb-csss-ebs-rg"

ssh_key_vault_name    = null # name of the key vault where public ssh key is stored
ssh_key_vault_rg_name = null # rg name of the key vault where public ssh key is stored
ado_subscription_id   = null

vmss_additional_tags = {
  iac            = "Terraform"
  env            = "uat"
  automated_by   = ""
  monitor_enable = true
}