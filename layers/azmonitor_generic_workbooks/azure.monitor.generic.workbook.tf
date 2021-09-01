resource "azurerm_template_deployment" "azgenericworkbook" {
    for_each                = var.az_monitoring_generic_workbooks
    name                    = each.value["workbookName"]
    deployment_mode         = "Incremental"
    resource_group_name     = data.azurerm_resource_group.this.name

    parameters = {
        "workbookDisplayName"       = each.value["workbookDisplayName"]
        "workbookSourceId"          = each.value["workbookSourceId"]
        "workbookSerializedData"    =  each.value["workbookSerializedData"]
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
      },
      "workbookSerializedData": {
        "type": "string",
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
          "serializedData": "[parameters('workbookSerializedData')]",
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

output "azgenericworkbook-id1" {
    value = [for x in azurerm_template_deployment.azgenericworkbook : x.id]
}