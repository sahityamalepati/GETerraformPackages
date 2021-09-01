# Design Decisions applicable: #1575, #1580, #1582, #1583, #1589, #1593, #1598, #3387
# Design Decisions not applicable: #1581, #1584, #1585, #1586, #1590, #1600, #1857

data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  count               = local.storage_state_exists == false ? 1 : 0
  name                = var.diagnostics_sa_name
  resource_group_name = var.diagnostics_sa_rgname == null ? var.resource_group_name : var.diagnostics_sa_rgname
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.vm_nics : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

data "azurerm_backup_policy_vm" "this" {
  for_each            = local.rsv_state_exists == false ? local.vms_for_backup : {}
  name                = each.value.vm_backup_policy_name
  recovery_vault_name = each.value.recovery_services_vault_name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                       = merge(var.vm_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  rsv_state_exists           = length(values(data.terraform_remote_state.recoveryservicesvault.outputs)) == 0 ? false : true
}

#
#- Availability Set
#
resource "azurerm_availability_set" "this" {
  for_each                     = var.availability_sets
  name                         = each.value["name"]
  location                     = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name          = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  platform_update_domain_count = coalesce(lookup(each.value, "platform_update_domain_count"), 5)
  platform_fault_domain_count  = coalesce(lookup(each.value, "platform_fault_domain_count"), 3)
}

# -
# - Azurerm Proximity Placement Group
# -

resource "azurerm_proximity_placement_group" "this" {
  for_each            = var.ppg
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  tags = local.tags
}

resource "azurerm_managed_disk" "osdisk" {
  for_each                = var.vms
  name                    = each.value["os_disk_name"]
  location                = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name     = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  storage_account_type    = (lookup(each.value, "managed_disk_type", null) == null) == true ? "Premium_LRS" : each.value["managed_disk_type"]
  create_option           = "Copy"
  source_resource_id      = each.value["source_snapshot_id"]
  disk_size_gb            = (lookup(each.value, "disk_size_gb", null) == null) == true ? "128" : each.value["disk_size_gb"]
#  zones                   = each.value["zone"] == null ? [] : each.value["zone"]
  zones                   = (lookup(each.value, "zone", null) == null) == true ? [] : [each.value["zone"]]
  os_type                 = each.value["source_snapshot_os_type"]
}

# -
# - Linux Virtual Machine
# -
resource "azurerm_virtual_machine" "vms" {
  for_each            = var.vms
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  network_interface_ids           = [for nic_k, nic_v in azurerm_network_interface.nics : nic_v.id if(contains(each.value["vm_nic_keys"], nic_k) == true)]
  vm_size                         = coalesce(lookup(each.value, "vm_size"), "Standard_DS1_v2")
  zones                           = (lookup(each.value, "zone", null) == null) == true ? null : [each.value["zone"]]
  availability_set_id             = lookup(each.value, "availability_set_key", null) == null ? null : lookup(azurerm_availability_set.this, each.value["availability_set_key"])["id"]
  proximity_placement_group_id    = lookup(each.value, "ppg_keys", null) == null ? null : lookup(azurerm_proximity_placement_group.this, each.value["ppg_keys"])["id"]
  storage_os_disk {
    name                      = azurerm_managed_disk.osdisk[each.key].name
    caching                   = coalesce(lookup(each.value, "storage_os_disk_caching"), "ReadWrite")
    os_type                   = azurerm_managed_disk.osdisk[each.key].os_type
    managed_disk_id           = azurerm_managed_disk.osdisk[each.key].id
    disk_size_gb              = lookup(each.value, "disk_size_gb", null)
    write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
    create_option             = lookup(each.value, "create_option", "Attach")
  }

  additional_capabilities {
    ultra_ssd_enabled = coalesce(each.value.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    enabled = true
    storage_uri = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_blob_endpoints_map, var.diagnostics_sa_name) : data.azurerm_storage_account.this.0.primary_blob_endpoint
  }

  lifecycle {
    ignore_changes = [
      network_interface_ids,
    ]
  }

  tags = local.tags

  depends_on = [azurerm_managed_disk.osdisk, azurerm_proximity_placement_group.this]

}

# -
# - Linux Network Interfaces
# -
resource "azurerm_network_interface" "nics" {
  for_each                      = var.vm_nics
  name                          = each.value.name
  location                      = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name           = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  internal_dns_name_label       = lookup(each.value, "internal_dns_name_label", null)
  enable_ip_forwarding          = lookup(each.value, "enable_ip_forwarding", null)
  enable_accelerated_networking = lookup(each.value, "enable_accelerated_networking", null)
  dns_servers                   = lookup(each.value, "dns_servers", null)

  dynamic "ip_configuration" {
    for_each = coalesce(each.value.nic_ip_configurations, [])
    content {
      name                          = coalesce(ip_configuration.value.name, format("%s00%d-ip", each.value.name, index(each.value.nic_ip_configurations, ip_configuration.value) + 1))
      subnet_id                     = lookup(each.value, "subnet_name", null) == null ? null : (local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"])
      private_ip_address_allocation = lookup(ip_configuration.value, "static_ip", null) == null ? "dynamic" : "static"
      private_ip_address            = lookup(ip_configuration.value, "static_ip", null)
      primary                       = index(each.value.nic_ip_configurations, ip_configuration.value) == 0 ? true : false
    }
  }

  tags = local.tags
}

# -
# - Linux Network Interfaces - Internal Backend Pools Association
# -
locals {
  nics_with_internal_bp_list = flatten([
    for nic_k, nic_v in var.vm_nics : [
      for backend_pool_name in coalesce(nic_v["lb_backend_pool_names"], []) :
      {
        key                     = "${nic_k}_${backend_pool_name}"
        nic_key                 = nic_k
        backend_address_pool_id = lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_backend_map_ids, backend_pool_name, null)
      }
    ]
  ])
  nics_with_internal_bp = {
    for bp in local.nics_with_internal_bp_list : bp.key => bp
  }
}

resource "azurerm_network_interface_backend_address_pool_association" "nics_with_internal_backend_pools" {
  for_each                = local.nics_with_internal_bp
  network_interface_id    = lookup(azurerm_network_interface.nics, each.value["nic_key"]).id
  ip_configuration_name   = lookup(azurerm_network_interface.nics, each.value["nic_key"]).ip_configuration[0].name
  backend_address_pool_id = each.value["backend_address_pool_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.nics]
}

#
# Linux Network Interfaces - NAT Rules Association
#
locals {
  nics_with_natrule_list = flatten([
    for nic_k, nic_v in var.vm_nics : [
      for nat_rule_name in coalesce(nic_v["lb_nat_rule_names"], []) :
      {
        key         = "${nic_k}_${nat_rule_name}"
        nic_key     = nic_k
        nat_rule_id = lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_natrule_map_ids, nat_rule_name, null)
      }
    ]
  ])
  nics_with_nat_rule = {
    for bp in local.nics_with_natrule_list : bp.key => bp
  }
}

resource "azurerm_network_interface_nat_rule_association" "this" {
  for_each              = local.nics_with_nat_rule
  network_interface_id  = lookup(azurerm_network_interface.nics, each.value["nic_key"]).id
  ip_configuration_name = lookup(azurerm_network_interface.nics, each.value["nic_key"]).ip_configuration[0].name
  nat_rule_id           = each.value["nat_rule_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.nics]
}

# -
# - Linux Network Interfaces - Application Security Groups Association
# -
locals {
  nics_with_asg_list = flatten([
    for nic_k, nic_v in var.vm_nics : [
      for asg_name in coalesce(nic_v["app_security_group_names"], []) :
      {
        key                           = "${nic_k}_${asg_name}"
        nic_key                       = nic_k
        application_security_group_id = lookup(data.terraform_remote_state.applicationsecuritygroup.outputs.app_security_group_ids_map, asg_name, null)
      }
    ]
  ])
  nics_with_asg = {
    for asg in local.nics_with_asg_list : asg.key => asg
  }
}

resource "azurerm_network_interface_application_security_group_association" "this" {
  for_each                      = local.nics_with_asg
  network_interface_id          = lookup(azurerm_network_interface.nics, each.value["nic_key"]).id
  application_security_group_id = each.value["application_security_group_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.nics]
}

# -
# - Linux Network Interfaces - Application Gateway's Backend Address Pools Association
# -
locals {
  nics_with_appgw_bp_list = flatten([
    for nic_k, nic_v in var.vm_nics : [
      for backend_pool_name in coalesce(nic_v["app_gateway_backend_pool_names"], []) :
      {
        key                     = "${nic_k}_${backend_pool_name}"
        nic_key                 = nic_k
        backend_address_pool_id = lookup(data.terraform_remote_state.applicationgateway.outputs.application_gateway_backend_pool_ids_map, backend_pool_name, null)
      }
    ]
  ])
  nics_with_appgw_bp = {
    for bp in local.nics_with_appgw_bp_list : bp.key => bp
  }
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "this" {
  for_each                = local.nics_with_appgw_bp
  network_interface_id    = lookup(azurerm_network_interface.nics, each.value["nic_key"]).id
  ip_configuration_name   = lookup(azurerm_network_interface.nics, each.value["nic_key"]).ip_configuration[0].name
  backend_address_pool_id = each.value["backend_address_pool_id"]

  lifecycle {
    ignore_changes = [network_interface_id]
  }

  depends_on = [azurerm_network_interface.nics]
}


# -
# - Azure Backup for an Linux Virtual Machine
# -
locals {
  vms_for_backup = {
    for vm_k, vm_v in var.vms :
    vm_k => vm_v if vm_v.recovery_services_vault_name != null
  }
}

resource "azurerm_backup_protected_vm" "this" {
  for_each            = length(values(local.vms_for_backup)) > 0 ? local.vms_for_backup : {}
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  recovery_vault_name = each.value["recovery_services_vault_name"]
  source_vm_id        = azurerm_virtual_machine.vms[each.key].id
  backup_policy_id    = local.rsv_state_exists == true ? lookup(data.terraform_remote_state.recoveryservicesvault.outputs.backup_policy_ids_map, each.value["recovery_services_vault_name"]) : lookup(data.azurerm_backup_policy_vm.this, each.key)["id"]
  depends_on          = [azurerm_virtual_machine.vms]
}

#########################################################
# Linux VM Managed Disk and VM & Managed Disk Attachment
#########################################################
locals {
  vms = {
    for vm_k, vm_v in var.vms :
    vm_k => {
      zone                       = vm_v.zone
      availability_set_key       = vm_v.availability_set_key
    }
  }
}

# -
# - Managed Disk
# - Design Decision #1575, #1580, #3387
# -
resource "azurerm_managed_disk" "this" {
  for_each            = var.managed_data_disks
  name                = lookup(each.value, "disk_name", null) == null ? "${azurerm_virtual_machine.vms[each.value["vm_key"]]["name"]}-datadisk-${each.value["lun"]}" : each.value["disk_name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  zones                  = lookup(lookup(local.vms, each.value["vm_key"]), "availability_set_key", null) == null ? (lookup(lookup(local.vms, each.value["vm_key"]), "zone", null) != null ? list(lookup(lookup(local.vms, each.value["vm_key"]), "zone")) : []) : []
  storage_account_type   = coalesce(lookup(each.value, "storage_account_type"), "Standard_LRS")
  disk_size_gb           = coalesce(lookup(each.value, "disk_size"), 1)
  os_type                = coalesce(lookup(each.value, "os_type"), "Linux")
  create_option          = coalesce(lookup(each.value, "create_option"), "Empty")
  source_resource_id     = coalesce(lookup(each.value, "create_option"), "Empty") == "Copy" ? each.value.source_resource_id : null

  tags = local.tags

  lifecycle {
    ignore_changes = [disk_encryption_set_id]
  }

  depends_on = [azurerm_virtual_machine.vms]
}

# -
# - Linux VM - Managed Disk Attachment
# -
resource "azurerm_virtual_machine_data_disk_attachment" "this" {
  for_each                  = var.managed_data_disks
  managed_disk_id           = lookup(lookup(azurerm_managed_disk.this, each.key), "id", null)
  virtual_machine_id        = azurerm_virtual_machine.vms[each.value["vm_key"]]["id"]
  lun                       = coalesce(lookup(each.value, "lun"), "10")
  caching                   = coalesce(lookup(each.value, "caching"), "ReadWrite")
  write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
  depends_on                = [azurerm_managed_disk.this, azurerm_virtual_machine.vms]
}
