locals { 
existing_subnet = { for k, v in var.sql_mi : k => v if lookup( v, "deploy_to_existing_subnet", false) == true } 
resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true
location                   = var.location == null ? (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location) : var.location
}

data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_subnet" "this" {
  for_each             = local.existing_subnet
  name                 = each.value.existing_subnet_name
  virtual_network_name = each.value.existing_vnet_name
  resource_group_name  = each.value.existing_subnet_rg_name != null ? each.value.existing_subnet_rg_name : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

data "azurerm_key_vault" "this" {
  count               = local.keyvault_state_exists == false ? 1 : 0
  name                = var.key_vault_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

# -
# - Generate Password for SQL MI
# -
resource "random_password" "this" {
  for_each         = var.sql_mi
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}


# -
# - Store SQL MI password in key valut
# -

resource "azurerm_key_vault_secret" "this" {
  for_each     = var.sql_mi
  name         = each.value["name"]
  value        = lookup(random_password.this, each.key)["result"]
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id

  lifecycle {
    ignore_changes = [value]
  }
}




resource "azurerm_template_deployment" "sql_mi" {
    for_each                = var.sql_mi
    deployment_mode         = "Incremental"
    name                    = each.value["name"]
    resource_group_name     = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

    parameters = {
        "name"                  = each.value["name"]
        "username"              = each.value["username"]
        "password"              = lookup(random_password.this, each.key)["result"]
        "skuname"               = coalesce(lookup(each.value ,"skuname"), "GP_Gen5")
        "subnetId"              = lookup(each.value, "deploy_to_existing_subnet", false) == true ? lookup(data.azurerm_subnet.this, each.key)["id"] :  lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value["subnetname"], null)
        "location"              = local.location
        "vCores"                = coalesce(lookup(each.value, "vcores"), 8)
        "minimalTlsVersion"     = coalesce(lookup(each.value,"minimum_tls_version"), 1.2)
        "storageSizeInGB"       = coalesce(lookup(each.value, "storage_size_in_gb"), 256)
        "collation"             = coalesce(lookup(each.value, "collation"), "Serbian_Cyrillic_100_CS_AS")
        "licenseType"           = coalesce(lookup(each.value,"license_type"),"LicenseIncluded")
        "tags"                  = jsonencode(var.sql_mi_tags)
    }

    template_body = <<DEPLOY
    {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.1",
    "parameters": {
        "name": {
            "type": "string"
        },
        "location": {
            "type": "string"
        },
        "username": {
            "type": "string"
        },
        "password": {
            "type": "securestring"
        },
        "subnetId": {
            "type": "string"
        },
        "skuname": {
            "type": "string"
        },
        "licenseType": {
            "type": "string"
        },
        "collation": {
            "type": "string"
        },
        "vCores": {
            "type": "string"
        },
        "storageSizeInGB": {
            "type": "string"
        },
        "minimalTlsVersion": {
            "type": "string"
        },
        "tags": {
            "type": "string"
        }
        
    },
    "resources": [
        {
            "name": "[parameters('name')]",
            "location": "[parameters('location')]",
            "sku": {
                "name": "[parameters('skuname')]",
                "tier": "GeneralPurpose"
            },
            "tags": "[json(parameters('tags'))]",
            "properties": {
                "administratorLogin": "[parameters('username')]",
                "administratorLoginPassword": "[parameters('password')]",
                "subnetId": "[parameters('subnetId')]",
                "storageSizeInGB": "[int(parameters('storageSizeInGB'))]",
                "vCores": "[int(parameters('vCores'))]",
                "licenseType": "[parameters('licenseType')]",
                "hardwareFamily": "Gen5",
                "collation": "[parameters('collation')]",
                "minimalTlsVersion": "[float(parameters('minimalTlsVersion'))]"
            },
            "type": "Microsoft.Sql/managedInstances",
            "identity": {
                "type": "SystemAssigned"
            },
            "apiVersion": "2020-02-02-preview"
        }


    ],
      "outputs": {
      "identity": {
          "type": "string",
          "value": "[reference(resourceId('Microsoft.Sql/managedInstances', parameters('name')),'2020-02-02-preview', 'Full').identity.principalId]"
        }  
       }
   }
    
    DEPLOY

 timeouts {
    create = var.deployment_time_out
    delete = var.deployment_time_out
  }
}

# -
# - Create DB in SQL MI
# -

resource "azurerm_template_deployment" "sql_mi_db" {
    for_each                = var.sql_mi_db
    deployment_mode         = "Incremental"
    name                    = each.value["name"]
    resource_group_name     = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

    parameters = {
        "name"                  = each.value["name"]
        "managedInstanceName"   = each.value["sql_mi_name"]
        "location"              = local.location
    }

    template_body = <<DEPLOY
    {
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.1",
    "parameters": {
        "name": {
            "type": "string"
        },
        "managedInstanceName": {
            "type": "string"
        },
        "location": {
        "type": "string"
        }       
    },
    "resources": [{
		"type": "Microsoft.Sql/managedInstances/databases",
		"apiVersion": "2020-02-02-preview",
		"name": "[concat(parameters('managedInstanceName'), '/',  parameters('name'))]",
		"location": "[parameters('location')]",
        "properties": {
        "createMode": "Default"
        }
    }
    
    ]
}
    
    DEPLOY

 timeouts {
    create = var.deployment_time_out
    delete = var.deployment_time_out
  }
depends_on = [azurerm_template_deployment.sql_mi]
}
