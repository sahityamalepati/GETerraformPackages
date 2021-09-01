resource_group_name = "dica01-eastus2-dev-cassandra-1026a2020rg"

linux_vms = {
   vm1 = {
    name                             = "dica01-eastus2-dev-jumpbox-vm0"
    vm_size                          = "Standard_DS1_v2"
    assign_identity                  = true
    availability_set_key             = null
    vm_nic_keys                      = ["nic1"]
    lb_backend_pool_names            = null
    lb_nat_rule_names                = null
    app_security_group_names         = null
    app_gateway_name                 = null
    zone                             = "1"
    subnet_name                      = "eastus2-30710-dica01-dev-vnet-01-app-snet"
    disable_password_authentication  = true
    source_image_reference_offer     = "UbuntuServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher = "Canonical"    # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer  
    source_image_reference_sku       = "18.04-LTS"    # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer 
    source_image_reference_version   = "Latest"       # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer             
    storage_os_disk_caching          = "ReadWrite"
    managed_disk_type                = "Premium_LRS"
    os_disk_name                     = "osdisklin30710"
    disk_size_gb                     = null
    write_accelerator_enabled        = null
    recovery_services_vault_name     = null 
    vm_backup_policy_name            = null #"tfex-recovery-vault-policy"
    customer_managed_key_name        = null
    disk_encryption_set_name         = null
    internal_dns_name_label          = null
    enable_ip_forwarding             = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking    = null # set it to true if you want to enable accelerated networking
    dns_servers                      = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "dica01-eastus2-dev-jumpbox-vm0"
      }
    ]
    enable_cmk_disk_encryption       = true # set it to true if you want to enable disk encryption using customer managed key
    custom_data_path                 = null #"//CustomData.tpl" # Optional
    custom_data_args                 = null #{ seed_nodes = "dica01-eastus2-dev-jumpbox-vm0", dc_location = "AZDICAEASTUS2DC", key_pass = "jumpbox", wl_vm_prefix = "dica01-eastus2-dev-jumpbox-vm" }
    diagnostics_storage_config_path  = null #""//Terraform//Diagnostics//Config.json" # Optional
    # custom_script = {
    #   commandToExecute   = null
    #   scriptPath         = "//PostDeployment.sh"
    #   scriptArgs         = { lun = "0", mount_point = "/datadisk", resource_group = "dica01-eastus2-dev-jumpbox-rg", kv_name = "dica01-eastus2-dev-kv-11", root_cert_name = "cert-root" }
    #   fileUris           = null
    #   storageAccountName = null
    # }
    # custom_script = {
    #   commandToExecute   = "sh script1.sh"
    #   scriptPath         = null
    #   scriptArgs         = null
    #   fileUris           = ["https://dica01dev10262020statt03.blob.core.windows.net/script/script1.sh"]
    #   storageAccountName = "dica01dev10262020statt03"
 }
}

linux_vm_nics = {
  nic1 = {
    name                          = "dica01-eastus2-dev-jumpbox-vm0-nic"
    subnet_name                   = "eastus2-30710-dica01-dev-vnet-01-app-snet"
    vnet_name                     = "eastus2-30710-dica01-dev-vnet-01" #"jstartvmfirst"
    networking_resource_group     = "dica01-eastus2-dev-cassandra-1026a2020rg"
    internal_dns_name_label       = null
    enable_ip_forwarding          = null # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking = null # set it to true if you want to enable accelerated networking
    dns_servers                   = null
    nic_ip_configurations = [
      {
        static_ip = null
        name      = "dica01-eastus2-dev-jumpbox-vm0"
      }
    ]
  }
}

administrator_user_name      = "demo"
administrator_login_password = "Nonesense!UseKeyvault2020"

diagnostics_sa_name = "dica01dev10262020statt03"

managed_data_disks = {
  "disk1" = {
    disk_name                 = "dica01-eastus2-dev-jumpbox-vm0-data-0"
    vm_key                    = "vm1"
    lun                       = 0
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  }
}

vm_additional_tags = {
  iac            = "Terraform"
  env            = "DEV"
  monitor_enable = true
}
