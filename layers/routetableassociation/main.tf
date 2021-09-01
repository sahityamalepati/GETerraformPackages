locals {

  subnet_route_table_associations = flatten([
    for association in coalesce(var.subnet_rt_association,[]) :
    {
      key = "${association.subnet_name}_${association.routetable_name}"
      subnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/${association.vnet_rg}/providers/Microsoft.Network/virtualNetworks/${association.vnet_name}/subnets/${association.subnet_name}"
      routetable_id = "/subscriptions/${var.subscription_id}/resourceGroups/${association.routetable_rg}/providers/Microsoft.Network/routeTables/${association.routetable_name}"
    }
  ])  

  association_list = {
    for rtassociation in local.subnet_route_table_associations : rtassociation.key => rtassociation
  }

}

# Associates a Route Table with a Subnet within a Virtual Network
resource "azurerm_subnet_route_table_association" "this" {
  for_each       = local.association_list
  route_table_id = each.value["routetable_id"]
  subnet_id      = each.value["subnet_id"]
}