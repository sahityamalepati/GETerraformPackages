variable "apm_monitoring_transaction_workbooks" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
  }))
  description = ""
  default     = {
    apmtransactionswb = {
        workbookName                = "Workbook Name"
        workbookDisplayName         = "Workbook Display Name"
        workbookSourceId            = "Source Id of workbook"
    }
  }
}