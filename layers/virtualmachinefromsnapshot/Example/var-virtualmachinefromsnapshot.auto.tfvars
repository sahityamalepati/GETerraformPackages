resource_group_name = "[__resoure_group_name__]"

vms = {
  vm1 = {
    name                                 = "[__vm_name__]"
    vm_size                              = "Standard_DS1_v2"
    availability_set_key                 = null
    ppg_keys                             = "ppg1"
    vm_nic_keys                          = ["nic1"]
    zone                                 = "1"
    source_snapshot_id                   = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-anf/providers/Microsoft.Compute/snapshots/snapshot-test-vm-ppgrg1"
    source_snapshot_os_type              = "Linux"
    os_disk_name                         = "[__osdisk_name__]"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = "128"
    write_accelerator_enabled            = null
    recovery_services_vault_name         = null
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    ultra_ssd_enabled                    = false
  },
  vm2 = {
    name                                 = "[__vm_name__]"
    vm_size                              = "Standard_DS1_v2"
    availability_set_key                 = null
    ppg_keys                             = "ppg2"
    vm_nic_keys                          = ["nic2"]
    zone                                 = "2"
    source_snapshot_id                   = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-anf/providers/Microsoft.Compute/snapshots/snapshot-test-vm-ppgrg1"
    source_snapshot_os_type              = "Linux"
    os_disk_name                         = "[__osdisk_name__]"
    storage_os_disk_caching              = "ReadWrite"
    managed_disk_type                    = "Premium_LRS"
    disk_size_gb                         = "128"
    write_accelerator_enabled            = null
    recovery_services_vault_name         = null
    vm_backup_policy_name                = null #"tfex-recovery-vault-policy"
    ultra_ssd_enabled                    = false
  }
}

vm_nics = {
  nic1 = {
    name                           = "vm-from-snapshot-nic1"
    subnet_name                    = "sn-ebs-dev"
    vnet_name                      = "277-gr-vnet"
    networking_resource_group      = "cs-connectedVNET-277"
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
        name      = "ip-config-first"
      }
    ]
  },
  nic2 = {
    name                           = "vm-from-snapshot2-nic1"
    subnet_name                    = "sn-ebs-scd6-dev"
    vnet_name                      = "277-gr-vnet"
    networking_resource_group      = "cs-connectedVNET-277"
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
        name      = "ip-config-first"
      }
    ]
  }
}

diagnostics_sa_name = "bdiagssatst"
diagnostics_sa_rgname = "testRG-sa-kv"

managed_data_disks = {
  "disk1" = {
    disk_name                 = "vm-from-snapshot-datadisk"
    vm_key                    = "vm1"
    lun                       = 10
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  },
  "disk2" = {
    disk_name                 = "vm-from-snapshot2-datadisk"
    vm_key                    = "vm2"
    lun                       = 1
    storage_account_type      = "Standard_LRS"
    disk_size                 = "1024"
    caching                   = "None"
    write_accelerator_enabled = false
    create_option             = null
    os_type                   = null
    source_resource_id        = null
  }
}

availability_sets = {}

ppg = {
    ppg1 = {
        name = "proximitypg-zone1"
    },
    ppg2 = {
        name = "proximitypg-zone2"
    }
}

vm_additional_tags = {
  iac            = "Terraform"
  env            = "uat"
  automated_by   = ""
  monitor_enable = true
}
