variable "jvm_workbooks" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
  }))
  description = "Map of Azure Monitor Scheduled Query Rules Alerts Specification."
  default     = {
    jvmwokrbook1 = {
        workbookName                = "Workbook Name"
        workbookDisplayName         = "Workbook Display Name"
        workbookSourceId            = "Source Id of workbook"
    }
  }
}