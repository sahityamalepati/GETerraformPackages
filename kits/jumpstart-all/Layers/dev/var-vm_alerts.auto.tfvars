subscriptionId = "04bb49da-c3e1-4bb6-89e1-a693b608d762"
tenantId       = "72f988bf-86f1-41af-91ab-2d7cd011db47"

resource_group_name = "jstart-all-dev-02012022"

vm_disktransfers_disk_alert = {
  vmdisktransfersdisk = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 100
  }
}

vm_linux_availablememory_memory_alert = {
  vmlam = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 1
  }
}

vm_linux_percentused_disk_alert = {
  vmlinuxpercentusedspacedisk = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 95
  }
}

vm_percentagelimit_cpu_alert = {
  vmplcpu = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 75
  }
}

vm_windows_availablememory_alert = {
  vmwam = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 512
  }
}

vm_windows_percentagefree_disk_alert = {
  vmwpfds = {
    scope         = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
    threshold     = 95
  }
}

vm_readwritebytespersec_network_alert = {
  vmrwbsa1 = {
    dataSourceId  = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
    actionGroupId = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourceGroups/jstart-all-dev-02012022/providers/microsoft.insights/actiongroups/ag02012022"
  }
}