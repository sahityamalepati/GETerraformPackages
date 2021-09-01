data "azurerm_resource_group" "this" {
  name = var.apimresourcegroup
}

resource "azurerm_api_management" "att-apim" {
  for_each             = var.api_management
  name                 = each.value["name"]
  location             = data.azurerm_resource_group.this.location
  resource_group_name  = data.azurerm_resource_group.this.name
  publisher_name       = each.value["publisher_name"]
  publisher_email      = each.value["publisher_email"]
  virtual_network_type = each.value["virtual_network_type"]
  virtual_network_configuration {
    subnet_id = lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name, null)
  }
  sku_name = each.value["sku_name"]
}



resource "azurerm_api_management_api" "attdemo" {
  for_each            = var.apimgmtdemo
  name                = each.value["name"]
  api_management_name = azurerm_api_management.att-apim[each.value.apim_key].name
  resource_group_name = var.apimresourcegroup
  revision            = each.value["revision"]
  display_name        = each.value["display_name"]
  path                = each.value["path"]
  protocols           = each.value["protocols"]

  dynamic "import" {
    for_each = lookup(each.value, "import", null) == null ? [] : list(lookup(each.value, "import"))
    content {
      content_format = import.value.content_format
      content_value  = import.value.content_value
    }
  }
}
