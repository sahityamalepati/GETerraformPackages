resource "azurerm_template_deployment" "vmssoperationswb" {
    for_each                = var.vm_vmssoperational_overview
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
      "defaultValue": "VMSS Operational Overview",
      "metadata": {
        "description": "The friendly name for the workbook that is used in the Gallery or Saved List.  This name must be unique within a resource group."
      }
    },
    "workbookType": {
      "type": "string",
      "defaultValue": "vm-insights",
      "metadata": {
        "description": "The gallery that the workbook will been shown under. Supported values include workbook, tsg, etc. Usually, this is 'workbook'"
      }
    },
    "workbookSourceId": {
      "type": "string",
      "defaultValue": "Azure Monitor",
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
      "name": "[parameters('workbookDisplayName')]",
      "type": "microsoft.insights/workbooks",
      "location": "[resourceGroup().location]",
      "apiVersion": "2018-06-17-preview",
      "dependsOn": [],
      "kind": "shared",
      "properties": {
        "displayName": "[parameters('workbookDisplayName')]",
        "serializedData": "{\"version\":\"Notebook/1.0\",\"items\":[{\"type\":1,\"content\":{\"json\":\"# Virtual Machine Scale Sets Operations\\r\\n\\r\\nThis workbook can be used to monitor the Virtual Machine Scale Sets capacity and helps in troubleshooting any underlying issues.\"},\"name\":\"text - 8\"},{\"type\":1,\"content\":{\"json\":\"# Parameters\"},\"name\":\"text - 9\"},{\"type\":9,\"content\":{\"version\":\"KqlParameterItem/1.0\",\"crossComponentResources\":[\"{Subscription}\"],\"parameters\":[{\"id\":\"de54a2bb-503c-4a01-9606-f54ccb56f3c2\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"TimeRange\",\"label\":\"Time Range\",\"type\":4,\"isRequired\":true,\"value\":{\"durationMs\":86400000},\"typeSettings\":{\"selectableValues\":[{\"durationMs\":300000},{\"durationMs\":900000},{\"durationMs\":1800000},{\"durationMs\":3600000},{\"durationMs\":14400000},{\"durationMs\":43200000},{\"durationMs\":86400000},{\"durationMs\":172800000},{\"durationMs\":259200000},{\"durationMs\":604800000},{\"durationMs\":1209600000},{\"durationMs\":2419200000},{\"durationMs\":2592000000},{\"durationMs\":5184000000},{\"durationMs\":7776000000}]},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"db012660-4637-45b9-b168-6baf0c384fa7\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"Subscription\",\"type\":6,\"isRequired\":true,\"value\":\"value::1\",\"typeSettings\":{\"additionalResourceOptions\":[\"value::1\"],\"includeAll\":false},\"timeContext\":{\"durationMs\":86400000}},{\"id\":\"7b2dc69f-5b7e-46bd-8977-20062bfaf35a\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"VMScaleSet\",\"label\":\"VM Scale Sets\",\"type\":5,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"query\":\"where type =~ 'microsoft.compute/virtualmachinescalesets'\\r\\n| summarize by id, name\",\"crossComponentResources\":[\"{Subscription}\"],\"value\":[\"value::all\"],\"typeSettings\":{\"additionalResourceOptions\":[\"value::all\"]},\"timeContext\":{\"durationMs\":86400000},\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"},{\"id\":\"707e6fd5-5463-4533-819b-487530f00bdf\",\"version\":\"KqlParameterItem/1.0\",\"name\":\"VMSS\",\"label\":\"VMSS ( AutoScale Settings)\",\"type\":5,\"isRequired\":true,\"multiSelect\":true,\"quote\":\"'\",\"delimiter\":\",\",\"query\":\"where type =~ 'microsoft.insights/autoscalesettings'\\r\\n| summarize by id\",\"crossComponentResources\":[\"{Subscription}\"],\"value\":[\"value::all\"],\"typeSettings\":{\"additionalResourceOptions\":[\"value::all\"]},\"timeContext\":{\"durationMs\":86400000},\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"}],\"style\":\"pills\",\"queryType\":1,\"resourceType\":\"microsoft.resourcegraph/resources\"},\"name\":\"parameters - 7\"},{\"type\":10,\"content\":{\"chartId\":\"workbook59b4a000-3d0d-46be-bf0b-435f7d6b1262\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMSS}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.insights/autoscalesettings\",\"resourceParameter\":\"VMSS\",\"metrics\":[{\"namespace\":\"microsoft.insights/autoscalesettings\",\"metric\":\"microsoft.insights/autoscalesettings--ScaleActionsInitiated\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Scale Actions Initiated\"}],\"title\":\"Scale Actions Initiated\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 0\"},{\"type\":10,\"content\":{\"chartId\":\"workbookc847ef4e-6b3c-473a-b1a1-ba30cd61f4d5\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMSS}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.insights/autoscalesettings\",\"resourceParameter\":\"VMSS\",\"metrics\":[{\"namespace\":\"microsoft.insights/autoscalesettings\",\"metric\":\"microsoft.insights/autoscalesettings--ObservedCapacity\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Observed Capacity\"}],\"title\":\"Observed Capacity\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 1\"},{\"type\":10,\"content\":{\"chartId\":\"workbook2788dfa8-17e3-4ffd-ada2-ab64e7401b41\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMScaleSet}\"],\"timeContext\":{\"durationMs\":86400000},\"resourceType\":\"microsoft.compute/virtualmachinescalesets\",\"resourceParameter\":\"VMScaleSet\",\"metrics\":[{\"namespace\":\"microsoft.compute/virtualmachinescalesets\",\"metric\":\"microsoft.compute/virtualmachinescalesets--Percentage CPU\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Percentage CPU\"}],\"title\":\"Percentage CPU\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 2\"},{\"type\":10,\"content\":{\"chartId\":\"workbookb99a375d-4994-4510-8c5b-8fbb006ef68e\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMScaleSet}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.compute/virtualmachinescalesets\",\"resourceParameter\":\"VMScaleSet\",\"metrics\":[{\"namespace\":\"microsoft.compute/virtualmachinescalesets\",\"metric\":\"microsoft.compute/virtualmachinescalesets--Network In Total\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Network In Total\"}],\"title\":\"Network In Total\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 3\"},{\"type\":10,\"content\":{\"chartId\":\"workbooka5a5aecf-821c-472a-9acb-9b8c61284594\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMScaleSet}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.compute/virtualmachinescalesets\",\"resourceParameter\":\"VMScaleSet\",\"metrics\":[{\"namespace\":\"microsoft.compute/virtualmachinescalesets\",\"metric\":\"microsoft.compute/virtualmachinescalesets--Network Out Total\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Network Out Total\"}],\"title\":\"Network Out Total\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 4\"},{\"type\":10,\"content\":{\"chartId\":\"workbook0b42b074-9bd0-4ab7-a256-f1402b2d2bde\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMScaleSet}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.compute/virtualmachinescalesets\",\"resourceParameter\":\"VMScaleSet\",\"metrics\":[{\"namespace\":\"microsoft.compute/virtualmachinescalesets\",\"metric\":\"microsoft.compute/virtualmachinescalesets--Disk Read Operations/Sec\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Disk Read Operations/Sec\"}],\"title\":\"Disk Read Operations/Sec\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 5\"},{\"type\":10,\"content\":{\"chartId\":\"workbook626e5472-5ae3-4780-acb3-82624b2019e9\",\"version\":\"MetricsItem/2.0\",\"size\":0,\"chartType\":2,\"metricScope\":0,\"resourceIds\":[\"{VMScaleSet}\"],\"timeContext\":{\"durationMs\":0},\"timeContextFromParameter\":\"TimeRange\",\"resourceType\":\"microsoft.compute/virtualmachinescalesets\",\"resourceParameter\":\"VMScaleSet\",\"metrics\":[{\"namespace\":\"microsoft.compute/virtualmachinescalesets\",\"metric\":\"microsoft.compute/virtualmachinescalesets--Disk Write Operations/Sec\",\"aggregation\":4,\"splitBy\":null,\"columnName\":\"Disk Write Operations/Sec\"}],\"title\":\"Disk Write Operations/Sec\",\"gridSettings\":{\"rowLimit\":10000}},\"name\":\"metric - 6\"}],\"isLocked\":false,\"fallbackResourceIds\":[\"azure monitor\"]}",
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

output "vmssoperationswb_ids" {
    value = [for x in azurerm_template_deployment.vmssoperationswb : x.id]
}