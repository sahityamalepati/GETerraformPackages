variable "vm_performancegraph_monitoring_workbooks" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    vmwbperfgraph = {
        workbookDisplayName         = ""
        workbookName                =  ""
        workbookSourceId            = ""
    }
  }
}