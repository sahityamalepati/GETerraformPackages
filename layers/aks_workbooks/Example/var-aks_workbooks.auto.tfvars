subscriptionId = "subscription_id"
tenantId = "tenant_id"

resource_group_name = "resource_group"

aks_pod_workbooks = {
    akspodwb1 = {
        workbookName                = "aks_pod_workbook_name"
        workbookDisplayName         = "aks_pod_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_id"
    }
}

aks_ns_workbooks = {
    aksnswb1 = {
        workbookName                = "aks_namespace_workbook_name"
        workbookDisplayName         = "aks_namespace_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_id"
    }
}

aks_node_workbooks = {
    aksnodewb1 = {
        workbookName                = "aks_node_workbook_name"
        workbookDisplayName         = "aks_pod_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_id"
    }
}