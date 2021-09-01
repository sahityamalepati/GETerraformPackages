variable "vm_percentagelimit_cpu_alert" {
  type = map(object({
    scope               = string
    actionGroupId       = string
    threshold           = number
  }))
  description = "Map of Azure Monitor Metric Rules Alerts Specification."
  default     = {
     vmplcpu = {
        scope               = "full_scope_id"
        actionGroupId       = "full_action_group_id"
        threshold           = 75
    }
  }
}