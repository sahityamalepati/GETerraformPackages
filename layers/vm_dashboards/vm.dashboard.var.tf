variable "vm_dashboards" {
    type = map(object({
        dashboardName               = string
        resourceGroupName           = string
        resourceName                = string
        resourceId                  = string
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    vmdash1 = {
        dashboardName               = "dashboard_name"
        resourceGroupName           = "workspace_rg_name"
        resourceName                = "workspace_name"
        resourceId                  = "full_workspace_id"
    }
  }
}