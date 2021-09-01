resource_group_name = "jstart-all-dev-02012022"

linux_vms = {
  vm1 = {
    name                                 = "jstartvm01"
    vm_size                              = "Standard_DS1_v2"
    assign_identity                      = true
    availability_set_key                 = null
    vm_nic_keys                          = ["nic1", "nic2"]
    zone                                 = "1"
    disable_password_authentication      = true
    source_image_reference_offer         = "UbuntuServer" # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_publisher     = "Canonical"    # set this to null if you are  using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_sku           = "18.04-LTS"    # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer
    source_image_reference_version       = "Latest"       # set this to null if you are using image id from shared image gallery or if you are passing image id to the VM through packer
    os_disk_name                         = "osdisklin123420"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = null
    write_accelerator_enabled            = null
    recovery_services_vault_name         = "tfex-recovery-vault"
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    customer_managed_key_name            = null
    disk_encryption_set_name             = null
    ultra_ssd_enabled                    = false
    use_existing_ssh_key                 = true           # set it to true if you want to use existing public ssh key
    secret_name_of_public_ssh_key        = null # key vault secret name of existing public ssh key
    enable_cmk_disk_encryption           = false          # set it to true if you want to enable disk encryption using customer managed key
    use_existing_disk_encryption_set     = false
    existing_disk_encryption_set_name    = null
    existing_disk_encryption_set_rg_name = null
    use_existing_ssh_key                 = false # set it to true if you want to use existing public ssh key
    secret_name_of_public_ssh_key        = null  # key vault secret name of existing public ssh key
    custom_data_path                     = null  #"//CustomData.tpl" # Optional
    custom_data_args                     = null  #"{ name = "VMandVM", destination = "EASTUS2", version = "1.0" }

  }
}

linux_vm_nics = {
  nic1 = {
    name = "jstartvm01-nic1"
    subnet_name = "loadbalancer"
    vnet_name = "jstartvmssfirst"#null
    networking_resource_group = "jstart-all-dev-02012022" #null
    lb_backend_pool_names = ["jstartalllbbackend", "jstartalllbbackendpublic"]
    lb_nat_rule_names = null
    app_security_group_names = null
    app_gateway_backend_pool_names = null
    internal_dns_name_label = null
    enable_ip_forwarding = null               # set it to true if you want to enable IP forwarding on the NIC
    enable_accelerated_networking = null      # set it to true if you want to enable accelerated networking
    dns_servers = null
    nic_ip_configurations = [
      {
        static_ip = null
        name = "ip-config-first"
      }
    ]
  }
}

administrator_user_name      = "demo"
administrator_login_password = null

diagnostics_sa_name  = "jstartall02012022sa"
key_vault_name       = null #"jstartall02012022kv"
kv_role_assignment   = false
self_role_assignment = false

managed_data_disks = {
  "disk1" = {
    disk_name                 = "diskvm02012022"
    vm_key                    = "vm1"
    lun                       = 10
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
  env            = "uat"
  automated_by   = ""
  monitor_enable = true
}
