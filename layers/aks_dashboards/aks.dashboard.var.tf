variable "aks_dashboards" {
    type = map(object({
        dashboardName               = string
        workspaceName               = string
        workspaceResourceGroup      = string
        workspaceResourceId         = string
        nodeWorkbookName            = string
        podWorkbookName             = string
        namespaceWorkbookName       = string
        
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    aksdash1 = {
        dashboardName               = "dashboard_name"
        workspaceName               = "workspace_name"
        workspaceResourceGroup      = "workspace_resource_group_name"
        workspaceResourceId         = "workspace_resource_id"
        nodeWorkbookName            = "node_workbook_name"
        podWorkbookName             = "pod_workbook_name"
        namespaceWorkbookName       = "namespace_workbook_name"
    }
  }
}