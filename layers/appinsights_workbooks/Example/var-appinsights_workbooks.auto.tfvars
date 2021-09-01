subscriptionId = "subscription_id"
tenantId = "tenant_id"

resource_group_name = "resource_group"

jvm_workbooks = {
    jvmwokrbook1 = {
        workbookName                = "jvm_workbook_name"
        workbookDisplayName         = "jvm_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_full_id"
    }
}

apm_monitoring_transaction_workbooks = {
    apmtransactionswb = {
        workbookName                = "apm_transaction_workbook_name"
        workbookDisplayName         = "apm_transaction_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_full_id"
    }
}

apm_monitoring_failures_workbooks = {
    apmfailureswb = {
        workbookName                = "apm_failures_workbook_name"
        workbookDisplayName         = "apm_failures_workbook_display_name"
        workbookSourceId            = "log_analytics_workspace_full_id"
    }
}

