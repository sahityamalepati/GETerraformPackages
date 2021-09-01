subscriptionId = "subscription_id"
tenantId = "tenant_id"

resource_group_name = "resource_group"

aks_dashboards = {
    aksdash1 = {
        dashboardName               = "aks_dashboard_name"
        workspaceName               = "log_analytics_workspace_name"
        workspaceResourceGroup      = "log_analytics_workspace_resource_group"
        workspaceResourceId         = "log_analytics_workspace_full_id"
        nodeWorkbookName            = "aks_node_workbook_name"
        podWorkbookName             = "aks_pod_workbook_name"
        namespaceWorkbookName       = "aks_namespace_workbook_name"
    }
}
