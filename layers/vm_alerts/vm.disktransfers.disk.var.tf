variable "vm_disktransfers_disk_alert" {
  type = map(object({
    scope               = string
    actionGroupId       = string
    threshold           = number
  }))
  description = "Map of Azure Monitor Metric Rules Alerts Specification."
  default     = {
     vmdisktransfersdisk = {
        scope               = "full_scope_id"
        actionGroupId       = "full_action_group_id"
        threshold           = 100
    }
  }
}