subscriptionId = "subscription_id"
tenantId = "tenant_id"

resource_group_name = "resource_group"

vm_disktransfers_disk_alert = {
    vmdisktransfersdisk = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 100
    }
}

vm_linux_availablememory_memory_alert = {
    vmlam = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 1
    }
}

vm_linux_percentused_disk_alert = {
    vmlinuxpercentusedspacedisk = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 95
    }
}

vm_percentagelimit_cpu_alert = {
    vmplcpu = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 75
    }
}

vm_windows_availablememory_alert = {
    vmwam = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 512
    }
}

vm_windows_percentagefree_disk_alert = {
    vmwpfds = {
        scope               = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
        threshold           = 95
    }
}

vm_readwritebytespersec_network_alert = {
    vmrwbsa1 = {
        dataSourceId        = "log_analytics_workspace_full_id"
        actionGroupId       = "action_group_full_id"
    }   
}