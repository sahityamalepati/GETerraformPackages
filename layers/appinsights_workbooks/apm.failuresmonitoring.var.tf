variable "apm_monitoring_failures_workbooks" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
  }))
  description = ""
  default     = {
     apmfailureswb = {
        workbookName                = "Workbook Name"
        workbookDisplayName         = "Workbook Display Name"
        workbookSourceId            = "Source Id of workbook"
    }
  }
}