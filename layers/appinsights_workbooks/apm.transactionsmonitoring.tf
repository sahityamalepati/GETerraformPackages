resource "azurerm_template_deployment" "apmtransactionswb" {
    for_each                = var.apm_monitoring_transaction_workbooks
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
          "serializedData": "{\"version\":\"Notebook/1.0\",\"items\":[{\"type\":1,\"content\":{\"json\":\"# Application Insights Workbook ( Transactions)\\r\\nUse this report to identify the overall monitoring of the Application. This workbook scopes over all the Application Insights resource or specific one in the subscription and help in identifying the trends and issues across application.\"},\"name\":\"text - 5\"},{\"type\":9,\"content\":{\"version\":\"KqlParameterItem/1.0\",\"parameters\":[{\"id\":\"93966171-84fc-4c16-ad18-6631d8a80f80\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"timeRange\",\"label\":\"Time Range\",\"type\":4,\"isRequired\":true,\"value\":{\"durationMs\":3600000},\"typeSettings\":{\"selectableValues\":[{\"durationMs\":300000},{\"durationMs\":900000},{\"durationMs\":3600000},{\"durationMs\":43200000},{\"durationMs\":86400000},{\"durationMs\":172800000},{\"durationMs\":259200000},{\"durationMs\":604800000},{\"durationMs\":1209600000},{\"durationMs\":2419200000},{\"durationMs\":2592000000},{\"durationMs\":5184000000},{\"durationMs\":7776000000}],\"allowCustom\":false},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"f8d3ed38-5baa-4a9f-b910-96cb43ddb887\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"subscription\",\"label\":\"Subscription\",\"type\":6,\"isRequired\":true,\"value\":\"value::1\",\"typeSettings\":{\"additionalResourceOptions\":[\"value::1\"],\"includeAll\":false},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"b0765c19-0ce5-44c6-80b5-384c77606de6\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Appinsightsresources\",\"label\":\"Application Insights\",\"type\":5,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"query\":\"where type =~ 'microsoft.insights/components'\\r\\n| project id\",\"crossComponentResources\":[\"{subscription}\"],\"value\":[\"value::all\"],\"typeSettings\":{\"resourceTypeFilter\":{\"microsoft.insights/components\":true},\"additionalResourceOptions\":[\"value::all\"]},\"timeContext\":{\"durationMs\":86400000},\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"}],\"style\":\"pills\",\"queryType\":0,\"resourceType\":\"microsoft.resourcegraph/resources\"},\"name\":\"workbookParams\"},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"\\r\\nlet data = requests\\r\\n| where timestamp {timeRange};\\r\\ndata\\r\\n| summarize Mean = avg(duration), (Median, p80, p95, p99) = percentiles(duration, 50, 80, 95, 99), Count = count(), Users = dcount(user_Id) by operation_Name, appName\\r\\n| project App = appName, Operation = operation_Name, Mean, Median, p80, p95, p99, Count, Users, rank = 2\\r\\n| union (data\\r\\n    | summarize Mean = avg(duration), (Median, p80, p95, p99) = percentiles(duration, 50, 80, 95, 99), Count = count(), Users = dcount(user_Id)\\r\\n    | project App = '🔸 All Apps', Operation = '🔸 All operations', Mean, Median, p80, p95, p99, Count, Users, rank = 1)\\r\\n| extend Relevance = Mean * Count\\r\\n| order by rank asc, Relevance desc\\r\\n| project-away Relevance, rank\\r\\n| extend Mean = round(Mean, 2), Median = round(Median, 1), p80 = round(p80, 2), p95 = round(p95, 2), p99 = round(p99, 2)\\r\\n| project App, Operation, Mean,Median,p80,p95,p99,Count,Users\\r\\n\\r\\n\\r\\n\",\"size\":2,\"title\":\"Application Performance Insights ( Duration )\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"Mean\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"Median\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"p80\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"p95\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"p99\",\"formatter\":8,\"formatOptions\":{\"palette\":\"red\"}},{\"columnMatch\":\"Count\",\"formatter\":8,\"formatOptions\":{\"palette\":\"blue\"}},{\"columnMatch\":\"Users\",\"formatter\":8,\"formatOptions\":{\"palette\":\"blueDark\"}}],\"sortBy\":[{\"itemKey\":\"$gen_heatmap_Mean_2\",\"sortOrder\":2}],\"labelSettings\":[{\"columnId\":\"App\"},{\"columnId\":\"Operation\"},{\"columnId\":\"Mean\"},{\"columnId\":\"Median\"},{\"columnId\":\"p80\"},{\"columnId\":\"p95\"},{\"columnId\":\"p99\"},{\"columnId\":\"Count\"},{\"columnId\":\"Users\"}]},\"sortBy\":[{\"itemKey\":\"$gen_heatmap_Mean_2\",\"sortOrder\":2}]},\"name\":\"Application Performance Insights \"},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"let grain = {timeRange:grain};\\r\\nperformanceCounters\\r\\n| where timestamp <= bin(now() - 1m, grain) and timestamp {timeRange:value}\\r\\n| where name == '% Processor Time'\\r\\n| summarize Data = avg(value) by cloud_RoleInstance, bin(timestamp, grain)\\r\\n\",\"size\":0,\"aggregation\":5,\"title\":\"Perf Counter (% Processor Time) by Machine \",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"visualization\":\"timechart\"},\"customWidth\":\"100\",\"name\":\"Perf Counters by Machine\"},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"// Page views trend \\r\\n// Chart the page views count, during the last day. \\r\\npageViews\\r\\n| where client_Type == 'Browser'\\r\\n| summarize count_sum = sum(itemCount) by bin(timestamp,30m)\\r\\n| render timechart\",\"size\":0,\"title\":\"Page views trend\",\"color\":\"grayBlue\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"]},\"customWidth\":\"50\",\"name\":\"Page views trend\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"\\r\\npageViews\\r\\n| where notempty(duration) and client_Type == 'Browser'\\r\\n| extend total_duration=duration*itemCount\\r\\n| summarize avg_duration=(sum(total_duration)/sum(itemCount)) by URL = url\\r\\n| top 5 by avg_duration desc\",\"size\":3,\"title\":\"Top 5 Slowest pages\",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"],\"visualization\":\"table\",\"gridSettings\":{\"formatters\":[{\"columnMatch\":\"URL\",\"formatter\":7,\"formatOptions\":{\"linkTarget\":\"Url\"},\"numberFormat\":{\"unit\":0,\"options\":{\"style\":\"decimal\"}}},{\"columnMatch\":\"avg_duration\",\"formatter\":3,\"formatOptions\":{\"palette\":\"greenRed\",\"aggregation\":\"Average\",\"compositeBarSettings\":{\"labelText\":\"\",\"columnSettings\":[]}}}]},\"tileSettings\":{\"showBorder\":false,\"titleContent\":{\"columnMatch\":\"url\",\"formatter\":1},\"leftContent\":{\"columnMatch\":\"avg_duration\",\"formatter\":12,\"formatOptions\":{\"palette\":\"auto\"},\"numberFormat\":{\"unit\":17,\"options\":{\"maximumSignificantDigits\":3,\"maximumFractionDigits\":2}}}}},\"customWidth\":\"50\",\"name\":\"Slowest pages\",\"styleSettings\":{\"maxWidth\":\"50%\"}},{\"type\":3,\"content\":{\"version\":\"KqlItem/1.0\",\"query\":\"// Top 10 countries by traffic \\r\\n// Chart the amount of requests from the top 10 countries. \\r\\nrequests\\r\\n| summarize CountByCountry=count() by client_CountryOrRegion\\r\\n| top 10 by CountByCountry\\r\\n| render piechart\",\"size\":3,\"title\":\"Top 10 countries by traffic \",\"timeContext\":{\"durationMs\":3600000},\"timeContextFromParameter\":\"timeRange\",\"queryType\":0,\"resourceType\":\"microsoft.insights/components\",\"crossComponentResources\":[\"{Appinsightsresources}\"]},\"name\":\"Top 10 countries by traffic \"}],\"isLocked\":false,\"fallbackResourceIds\":[\"\"]}",
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

output "apmtransactionswb-id1" {
    value = [for x in azurerm_template_deployment.apmtransactionswb : x.id]
}