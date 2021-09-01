resource_group_name                     = "dr-test-secondary-rg" # name of the RG where you want to create the vault. Location of this RG should be the target region for DR

recovery_services_vaults                = {
    rsv1 = {
        name                                = "wudrrsv-test"
        sku                                 = "Standard"
        soft_delete_enabled                 = false
        primary_region                      = "eastus" # source region
        #recovery_cache_rg                   = "cachesarsv-eastus-rg1" # recovery cache RG - this will be created automatically
        replication_policies    = [{
            asr_replication_policy_name     = "testreplicationpolicy"
            recovery_point_retention_in_minutes = 720
            application_consistent_snapshot_frequency_in_minutes = 220
        },
        {
            asr_replication_policy_name     = "testreplicationpolicy1"
            recovery_point_retention_in_minutes = 1440
            application_consistent_snapshot_frequency_in_minutes = 120
        }
        ]
        network_mapping                     = [{
            name                            = "networkmapping"
            primary_vnet_id                 = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/cs-connectedVNET-277/providers/Microsoft.Network/virtualNetworks/277-gr-vnet"
            secondary_vnet_id               = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/DR-test-vnet-RG/providers/Microsoft.Network/virtualNetworks/277-dr-gr-vnet"
        }]

        protected_items                     = [
        {
            source_vm_id                    = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-automation-account-rg/providers/Microsoft.Compute/virtualMachines/testVMdes1"
            source_osdisk_id                = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-automation-account-rg/providers/Microsoft.Compute/disks/testVMdes1-osdisk"
            source_datadisk_ids             = ["/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-automation-account-rg/providers/Microsoft.Compute/disks/testVMdes1-datadisk"]
            source_nic_id                   = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/test-automation-account-rg/providers/Microsoft.Network/networkInterfaces/testVMdes1-nic"
            target_resource_group_name      = "DR-test-vnet-RG"
            target_subnet_name              = "sn-bastion-dev"
            asr_replication_policy_name     = "testreplicationpolicy1"
            cmk_disk_encryption_enabled     = true
            target_disk_encryption_set_name = "prpooldes"
            target_disk_encryption_set_rg_name = "dr-test-secondary-rg"
            target_ppg_name                 = "ppgzone1"
        }
        ]
    }
}

rsv_additional_tags      = {

}