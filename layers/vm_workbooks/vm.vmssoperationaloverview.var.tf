variable "vm_vmssoperational_overview" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    vmssoperationswb = {
        workbookDisplayName         = ""
        workbookName                = ""
        workbookSourceId            = ""
    }
  }
}