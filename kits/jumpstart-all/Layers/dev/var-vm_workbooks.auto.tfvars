subscriptionId = "04bb49da-c3e1-4bb6-89e1-a693b608d762"
tenantId       = "72f988bf-86f1-41af-91ab-2d7cd011db47"

resource_group_name = "jstart-all-dev-02012022"

vm_performanceanalysis_monitoring_workbooks = {
  vmwbperfanalysis = {
    workbookDisplayName = "vmpawb"
    workbookName        = "VM-PA-Workbook"
    workbookSourceId    = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
  }
}

vm_performancegraph_monitoring_workbooks = {
  vmwbperfgraph = {
    workbookDisplayName = "vmpgwb"
    workbookName        = "VM-PG-Workbook"
    workbookSourceId    = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
  }
}

vm_vmssoperational_overview = {
  vmssoperationswb = {
    workbookDisplayName = "vmvowb"
    workbookName        = "VM-Operation-Workbook"
    workbookSourceId    = "/subscriptions/04bb49da-c3e1-4bb6-89e1-a693b608d762/resourcegroups/jstart-all-dev-02012022/providers/microsoft.operationalinsights/workspaces/jstartall02012022law"
  }
}