variable "az_monitoring_generic_workbooks" {
  type = map(object({
    workbookName                = string
    workbookDisplayName         = string
    workbookSourceId            = string
    workbookSerializedData       = string
  }))
  description = "Generic workbook deployment template"
  default     = {
    azgenericworkbook = {
        workbookName                = "Workbook Name"
        workbookDisplayName         = "Workbook Display Name"
        workbookSourceId            = "Source Id of workbook"
        workbookSerializedData       =  "workbook Serialized Data"
    }
  }
}