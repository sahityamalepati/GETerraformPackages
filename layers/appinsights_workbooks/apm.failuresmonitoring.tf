
resource "azurerm_template_deployment" "apmfailureswb" {
    for_each                = var.apm_monitoring_failures_workbooks
    name                    = each.value["workbookName"]
    deployment_mode         = "Incremental"
    resource_group_name     = data.azurerm_resource_group.this.name

    parameters = {
        "workbookDisplayName"   = each.value["workbookDisplayName"]
        "workbookSourceId"      = each.value["workbookSourceId"]
    }

    template_body = <<DEPLOY
    {
    "contentVersion": "1.0.0.0",
    "parameters": {
      "workbookDisplayName": {
        "type": "string",
        "defaultValue": "<workbook_display_name>",
        "metadata": {
          "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
        }
      },
      "workbookType": {
        "type": "string",
        "defaultValue": "workbook",
        "metadata": {
          "description": "The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is 'workbook'"
        }
      },
      "workbookSourceId": {
        "type": "string",
        "defaultValue": "<workbook_source_id>",
        "metadata": {
          "description": "The id of resource instance to which the workbook will be associated"
        }
      },
      "workbookId": {
        "type": "string",
        "defaultValue": "[newGuid()]",
        "metadata": {
          "description": "The unique guid for this workbook instance"
        }
      }
    },
    "resources": [
      {
        "name": "[parameters('workbookId')]",
        "type": "microsoft.insights/workbooks",
        "location": "[resourceGroup().location]",
        "apiVersion": "2018-06-17-preview",
        "dependsOn": [],
        "kind": "shared",
        "properties": {
          "displayName": "[parameters('workbookDisplayName')]",
          "serializedData": "{\"version\":\"Notebook/1.0\",\"items\":[{\"type\":1,\"content\":{\"json\":\"# Application Insights Workbook (Failures)\\r\\nUse this report to identify the  overall failures of an Application. This workbook scopes over all the Application Insights resources or specific one in the subscription and help in identifying the trends and issues across the application.\"},\"name\":\"text - 5\"},{\"type\":9,\"content\":{\"version\":\"KqlParameterItem/1.0\",\"parameters\":[{\"id\":\"93966171-84fc-4c16-ad18-6631d8a80f80\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"timeRange\",\"label\":\"Time Range\",\"type\":4,\"isRequired\":true,\"value\":{\"durationMs\":3600000},\"typeSettings\":{\"selectableValues\":[{\"durationMs\":300000},{\"durationMs\":900000},{\"durationMs\":3600000},{\"durationMs\":43200000},{\"durationMs\":86400000},{\"durationMs\":172800000},{\"durationMs\":259200000},{\"durationMs\":604800000},{\"durationMs\":1209600000},{\"durationMs\":2419200000},{\"durationMs\":2592000000},{\"durationMs\":5184000000},{\"durationMs\":7776000000}],\"allowCustom\":false},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"f8d3ed38-5baa-4a9f-b910-96cb43ddb887\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"subscription\",\"label\":\"Subscription\",\"type\":6,\"isRequired\":true,\"value\":\"value::1\",\"typeSettings\":{\"additionalResourceOptions\":[\"value::1\"],\"includeAll\":false},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"b0765c19-0ce5-44c6-80b5-384c77606de6\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Appinsightsresources\",\"label\":\"Application Insights\",\"type\":5,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"query\":\"where type =~ 'microsoft.insights/components'\\r\\n| project id\",\"crossComponentResources\":[\"{subscription}\"],\"value\":[\"value::all\"],\"typeSettings\":{\"resourceTypeFilter\":{\"microsoft.insights/components\":true},\"additionalResourceOptions\":[\"value::all\"]},\"timeContext\":{\"durationMs\":86400000},\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"}],\"style\":\"pills\",\"queryType\":0,\"resourceType\":\"microsoft.resourcegraph/resources\"},\"name\":\"workbookParams\"},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"let data = requests\\r\\n| where timestamp {timeRange};\\r\\ndata\\r\\n| summarize Users = dcount(user_Id), CountFailed = countif(success == false), Count = count() by name, appName\\r\\n| project App = appName, Operation = name, ['Count (Failed)'] = CountFailed, Count, ['Success %'] = round(100.0 * (Count - CountFailed) / Count, 2), Users\\r\\n| union (data\\r\\n    | summarize Users = dcount(user_Id), CountFailed = countif(success == false), Count = count()\\r\\n    | project App = '🔸 All Apps', Operation = '🔸 All operations', Users, ['Count (Failed)'] = CountFailed, Count, ['Success %'] = round(100.0 * (Count - CountFailed) / Count, 2))\\r\\n| order by ['Count (Failed)'] desc\\r\\n\",\"size\":0,\"title\":\"Application Failures Insights\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Count (Failed)\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"Count\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"blue\"}},{\"columnMatch\":\"Success %\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"max\":100,\"palette\":\"redGreen\"}},{\"columnMatch\":\"Users\",\"formatter\":8,\"formatOptions\":{\"min\":0,\"palette\":\"blueDark\"}}],\"sortBy\":[{\"itemKey\":\"$gen_heatmap_Count (Failed)_2\",\"sortOrder\":2}],\"labelSettings\":[{\"columnId\":\"App\"},{\"columnId\":\"Operation\"},{\"columnId\":\"Count\"},{\"columnId\":\"Users\"}]},\"sortBy\":[{\"itemKey\":\"$gen_heatmap_Count (Failed)_2\",\"sortOrder\":2}]},\"name\":\"Application Failures Insights\"},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"\\r\\nrequests\\r\\n| where timestamp {timeRange}\\r\\n| make-series FailedRequest = countif(success == false) default = 0 on timestamp in range({timeRange:start}, {timeRange:end}, {timeRange:grain})\\r\\n| mvexpand timestamp to typeof(datetime), FailedRequest to typeof(long)\\r\\n\",\"size\":0,\"title\":\"Failed Operations ( Count )\",\"color\":\"green\",\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"visualization\":\"timechart\"},\"customWidth\":\"50\",\"name\":\"Failed Operations\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"let operation = tostring(\\\"🔸 All operations\\\");\\r\\nlet app = tostring(\\\"🔸 All Apps\\\");\\r\\nrequests\\r\\n| where timestamp {timeRange}\\r\\n| where (name == operation and appName == app) or (operation == '' and app == '') or (operation == '🔸 All operations' and app == '🔸 All Apps')\\r\\n| where success == false\\r\\n| summarize ['Failing Requests'] = count() by ['Result Code'] = tostring(resultCode)\\r\\n| top 4 by ['Failing Requests'] desc\\r\\n\",\"size\":1,\"title\":\"Top Failure Codes\",\"color\":\"grayBlue\",\"noDataMessage\":\"No failiures found\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Failing Requests\",\"formatter\":4,\"formatOptions\":{\"min\":0,\"palette\":\"red\"}}]}},\"customWidth\":\"50\",\"name\":\"Top Failure Codes\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"\\r\\nlet operations = toscalar(requests\\r\\n| where timestamp {timeRange}\\r\\n| summarize by operation_Id\\r\\n| summarize makelist(operation_Id, 1000000));\\r\\nexceptions\\r\\n| where timestamp {timeRange}\\r\\n| where operation_Id in (operations)\\r\\n| summarize ['Failing Requests'] = count() by ['Exception'] = type\\r\\n| top 4 by ['Failing Requests'] desc\\r\\n\",\"size\":1,\"title\":\"Top Exceptions\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"visualization\":\"table\",\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Failing Requests\",\"formatter\":4,\"formatOptions\":{\"min\":0,\"palette\":\"red\"}}]},\"tileSettings\":{\"showBorder\":false,\"titleContent\":{\"columnMatch\":\"url\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"avg_duration\",\"formatter\":12,\"formatOptions\":{\"palette\":\"auto\"},\"numberFormat\":{\"unit\":17,\"options\":{\"maximumSignificantDigits\":3,\"maximumFractionDigits\":2}}}}},\"customWidth\":\"50\",\"name\":\"Top Exceptions\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"\\r\\nlet operations = toscalar(requests\\r\\n| where timestamp {timeRange}\\r\\n| summarize by operation_Id\\r\\n| summarize makelist(operation_Id, 1000000));\\r\\ndependencies\\r\\n| where timestamp {timeRange}\\r\\n| where operation_Id in (operations)\\r\\n| where success == false\\r\\n| summarize ['Failing Dependencies'] = count() by ['Dependency'] = name\\r\\n| top 4 by ['Failing Dependencies'] desc\\r\\n\",\"size\":1,\"title\":\"Top Failing Dependencies\",\"noDataMessage\":\"No failed dependencies found.\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Failing Dependencies\",\"formatter\":4,\"formatOptions\":{\"min\":0,\"palette\":\"red\"}}]}},\"customWidth\":\"50\",\"name\":\"Top Failing Dependencies\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"exceptions\\r\\n| where notempty(client_Browser) and client_Type == 'Browser'\\r\\n| summarize total_exceptions = sum(itemCount) by Exception = problemId\\r\\n| top 3 by total_exceptions desc\",\"size\":1,\"title\":\"Top 3 browser exceptions\",\"noDataMessage\":\"No Browser Exceptions Found\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"total_exceptions\",\"formatter\":4,\"formatOptions\":{\"palette\":\"red\"}}]}},\"customWidth\":\"50\",\"name\":\"Top 3 browser exceptions\"}],\"isLocked\":false,\"fallbackResourceIds\":[\"\"]}",
          "version": "1.0",
          "sourceId": "[parameters('workbookSourceId')]",
          "category": "[parameters('workbookType')]"
        }
      }
    ],
    "outputs": {
      "workbookId": {
        "type": "string",
        "value": "[resourceId( 'microsoft.insights/workbooks', parameters('workbookId'))]"
      }
    },
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#"
  }

    DEPLOY
}

output "apmfailureswb-id1" {
    value = [for x in azurerm_template_deployment.apmfailureswb : x.id]
}