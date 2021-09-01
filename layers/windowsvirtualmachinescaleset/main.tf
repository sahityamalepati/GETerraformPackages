# Design Decisions applicable: #1575, #1580, #1582, #1583, #1589, #1593, #1598, #3387
# Design Decisions not applicable: #1581, #1584, #1585, #1586, #1590, #1600, #1857

data "azurerm_resource_group" "this" {
  count = local.resourcegroup_state_exists == false ? 1 : 0
  name  = var.resource_group_name
}

data "azurerm_storage_account" "this" {
  count               = local.storage_state_exists == false ? 1 : 0
  name                = var.diagnostics_sa_name
  #resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
   resource_group_name = var.diagnostics_sa_rgname == null ? var.resource_group_name : var.diagnostics_sa_rgname
}

data "azurerm_subnet" "this" {
  for_each             = local.networking_state_exists == false ? var.virtual_machine_scalesets : {}
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.networking_resource_group != null ? each.value.networking_resource_group : (local.resourcegroup_state_exists == false ? var.resource_group_name : data.azurerm_resource_group.this.0.name)
}

data "azurerm_key_vault" "this" {
  count               = local.keyvault_state_exists == false ? 1 : 0
  name                = var.key_vault_name
 # resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
 resource_group_name = var.key_vault_rgname == null ? var.resource_group_name : var.key_vault_rgname
}

# -
# - Get the current user config
# -
data "azurerm_client_config" "current" {}

locals {
  tags                       = merge(var.vmss_additional_tags, (local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_tags_map, var.resource_group_name) : data.azurerm_resource_group.this.0.tags))
  resourcegroup_state_exists = length(values(data.terraform_remote_state.resourcegroup.outputs)) == 0 ? false : true
  storage_state_exists       = length(values(data.terraform_remote_state.storage.outputs)) == 0 ? false : true
  networking_state_exists    = length(values(data.terraform_remote_state.networking.outputs)) == 0 ? false : true
  keyvault_state_exists      = length(values(data.terraform_remote_state.keyvault.outputs)) == 0 ? false : true

  key_permissions         = ["Get", "List", "Update", "Create", "Delete", "Purge"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Delete", "Purge", "Import"]
  storage_permissions     = ["delete", "get", "list", "purge", "set", "update"]

  backend_pool_ids = {
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    vmss_k => [
      for backend_pool_name in coalesce(vmss_v["lb_backend_pool_names"], []) :
      lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_backend_map_ids, backend_pool_name, null)
    ]
  }

  #app_security_group_ids = {
  #  for vmss_k, vmss_v in var.virtual_machine_scalesets :
  #  vmss_k => [
  #    for asg_name in coalesce(vmss_v["app_security_group_names"], []) :
  #    lookup(data.terraform_remote_state.applicationsecuritygroup.outputs.app_security_group_ids_map, asg_name, null)
  #  ]
  #}

  vmss_with_asg_list = flatten([
    for vmss_k, vmss_v in var.virtual_machine_scalesets : [
      for asg in coalesce(vmss_v.application_security_groups, []) : 
      {
        key        = format("%s_%s", vmss_k, asg.name)
        asg_name   = asg.name
        vmss_key   = vmss_k
        asg_rgname = asg.resource_group
      } if(asg.name != null)
    ]
  ])

  vmss_with_asg = {
        for asg in local.vmss_with_asg_list : asg.key => asg
  }

  vmss_with_asg_id = {
        for asg in local.vmss_with_asg_list : asg.vmss_key => data.azurerm_application_security_group.vmss_with_asg[asg.key].id...
  }

  nat_pool_ids = {
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    vmss_k => [
      for nat_pool_name in coalesce(vmss_v["lb_nat_pool_names"], []) :
      lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_natpool_map_ids, nat_pool_name, null)
    ]
  }

  default_rolling_upgrade_policy = {
    max_batch_instance_percent              = 20
    max_unhealthy_instance_percent          = 20
    max_unhealthy_upgraded_instance_percent = 5
    pause_time_between_batches              = "PT0S"
  }
}

# -
# - Generate Password for Windows Virtual Machine Scaleset
# -
resource "random_password" "this" {
  for_each         = var.virtual_machine_scalesets
  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_special      = 2
  number           = true
  special          = true
  override_special = "!@#$%&"
}
# -
# - Store Generated Password to Key Vault Secrets
# - Design Decision #1582
# -
resource "azurerm_key_vault_secret" "this" {
  for_each     = var.virtual_machine_scalesets
  name         = each.value["name"]
  value        = lookup(random_password.this, each.key)["result"]
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id

  lifecycle {
    ignore_changes = [value]
  }
}

data "azurerm_application_security_group" "vmss_with_asg" {
  for_each             = local.vmss_with_asg
  name                 = each.value.asg_name
  resource_group_name  = each.value.asg_rgname != null ? each.value.asg_rgname : (local.resourcegroup_state_exists == true ? var.resource_group_name : "")
}

# -
# - Windows Virtual Machines Scalesets
# -
resource "azurerm_windows_virtual_machine_scale_set" "this" {
  for_each            = var.virtual_machine_scalesets
  name                = each.value["name"]
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name

  # Automatic rolling upgrade - depends on health probe or health extension  
  upgrade_mode = coalesce(lookup(each.value, "upgrade_mode"), "Manual")

  dynamic "rolling_upgrade_policy" {
    for_each = coalesce(lookup(each.value, "upgrade_mode"), "Manual") == "Manual" ? [] : (each.value.rolling_upgrade_policy != null ? [each.value.rolling_upgrade_policy] : [local.default_rolling_upgrade_policy])
    content {
      max_batch_instance_percent              = rolling_upgrade_policy.value.max_batch_instance_percent
      max_unhealthy_instance_percent          = rolling_upgrade_policy.value.max_unhealthy_instance_percent
      max_unhealthy_upgraded_instance_percent = rolling_upgrade_policy.value.max_unhealthy_upgraded_instance_percent
      pause_time_between_batches              = rolling_upgrade_policy.value.pause_time_between_batches
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = coalesce(lookup(each.value, "enable_automatic_instance_repair"), false) == true ? list(each.value.automatic_instance_repair_grace_period) : []
    content {
      enabled      = true
      grace_period = automatic_instance_repair.value
    }
  }

  # Required when using rolling upgrade policy or automatic instance repair
  health_probe_id = coalesce(lookup(each.value, "upgrade_mode"), "Manual") == "Manual" && coalesce(lookup(each.value, "enable_automatic_instance_repair"), false) == false ? null : lookup(data.terraform_remote_state.loadbalancer.outputs.pri_lb_probe_map_ids, each.value["lb_probe_name"], null)

  # A collection of availability zones to spread the Virtual Machines over
  zones = coalesce(lookup(each.value, "upgrade_mode"), "Manual") == "Manual" ? lookup(each.value, "zones", null) : var.zones

  sku            = coalesce(lookup(each.value, "vm_size"), "Standard_DS1_v2")
  instances      = each.value["instances"]
  admin_username = var.administrator_user_name
  admin_password = lookup(random_password.this, each.key)["result"]

  dynamic "source_image_reference" {
    for_each = lookup(local.windows_image_ids, each.value["name"], null) == null ? (lookup(each.value, "source_image_reference_publisher", null) == null ? [] : [lookup(each.value, "source_image_reference_publisher", null)]) : []
    content {
      publisher = lookup(each.value, "source_image_reference_publisher", null)
      offer     = lookup(each.value, "source_image_reference_offer", null)
      sku       = lookup(each.value, "source_image_reference_sku", null)
      version   = lookup(each.value, "source_image_reference_version", null)
    }
  }

  enable_automatic_updates = lookup(each.value, "enable_automatic_updates", null)
  computer_name_prefix     = lookup(each.value, "computer_name_prefix", null) != null ? each.value.computer_name_prefix : each.value.name
  custom_data              = lookup(each.value, "custom_data_path", null) == null ? null : (base64encode(templatefile("${path.root}.${each.value["custom_data_path"]}", each.value["custom_data_args"] != null ? each.value["custom_data_args"] : {})))
  source_image_id          = lookup(local.windows_image_ids, each.value["name"], null)

  os_disk {
    caching                   = coalesce(lookup(each.value, "storage_os_disk_caching"), "ReadWrite")
    storage_account_type      = coalesce(lookup(each.value, "managed_disk_type"), "Standard_LRS")
    disk_size_gb              = lookup(each.value, "disk_size_gb", null)
    write_accelerator_enabled = lookup(each.value, "write_accelerator_enabled", null)
    disk_encryption_set_id    = coalesce(lookup(each.value, "enable_cmk_disk_encryption"), false) == true ? lookup(azurerm_disk_encryption_set.this, each.key)["id"] : null
  }

  # - Design Decision #1575, #1580, #3387
  dynamic "data_disk" {
    for_each = coalesce(lookup(each.value, "storage_profile_data_disks"), [])
    content {
      lun                       = data_disk.value.lun
      caching                   = coalesce(lookup(data_disk.value, "caching"), "ReadWrite")
      storage_account_type      = coalesce(lookup(data_disk.value, "managed_disk_type"), "Standard_LRS")
      disk_size_gb              = data_disk.value.disk_size_gb
      write_accelerator_enabled = lookup(data_disk.value, "write_accelerator_enabled", null)
      disk_encryption_set_id    = coalesce(lookup(each.value, "enable_cmk_disk_encryption"), false) == true ? lookup(azurerm_disk_encryption_set.this, each.key)["id"] : null
    }
  }

  network_interface {
    name                          = "${each.value["name"]}-nic"
    primary                       = true
    enable_accelerated_networking = coalesce(lookup(each.value, "enable_accelerated_networking"), false)
    enable_ip_forwarding          = coalesce(lookup(each.value, "enable_ip_forwarding"), false)
    ip_configuration {
      name                                         = "${each.value["name"]}-ip"
      primary                                      = true
      subnet_id                                    = lookup(each.value, "subnet_name", null) != null ? (local.networking_state_exists == true ? lookup(data.terraform_remote_state.networking.outputs.map_subnet_ids, each.value.subnet_name) : lookup(data.azurerm_subnet.this, each.key)["id"]) : null
      load_balancer_backend_address_pool_ids       = lookup(local.backend_pool_ids, each.key, null)
      load_balancer_inbound_nat_rules_ids          = lookup(local.nat_pool_ids, each.key, null)
      #application_security_group_ids               = lookup(local.app_security_group_ids, each.key, null)
      application_security_group_ids               = lookup(local.vmss_with_asg_id, each.key, null)
      application_gateway_backend_address_pool_ids = each.value["app_gateway_name"] != null ? coalesce(lookup(data.terraform_remote_state.applicationgateway.outputs.application_gateway_backend_pools_map, each.value["app_gateway_name"]), null) : null
    }
  }

  dynamic "automatic_os_upgrade_policy" {
    for_each = (coalesce(lookup(each.value, "upgrade_mode"), "Manual") == "Automatic" && lookup(each.value, "enable_automatic_os_upgrade", true) == true) ? [true] : []
    content {
      disable_automatic_rollback  = false
      enable_automatic_os_upgrade = true
    }
  }

  additional_capabilities {
    ultra_ssd_enabled = coalesce(each.value.ultra_ssd_enabled, false)
  }

  boot_diagnostics {
    storage_account_uri = local.storage_state_exists == true ? lookup(data.terraform_remote_state.storage.outputs.primary_blob_endpoints_map, var.diagnostics_sa_name) : data.azurerm_storage_account.this.0.primary_blob_endpoint
  }

  # Design Decision #1583
  dynamic "identity" {
    for_each = coalesce(lookup(each.value, "assign_identity"), false) == false ? [] : list(coalesce(lookup(each.value, "assign_identity"), false))
    content {
      type = "SystemAssigned"
    }
  }

  tags = local.tags

  lifecycle {
    ignore_changes = [
#      instances,
      admin_password,
      os_disk[0].disk_encryption_set_id
    ]
  }

  depends_on = [azurerm_disk_encryption_set.this, azurerm_key_vault_access_policy.cmk]
}

# -
# - Create Key Vault Accesss Policy for VMSS MSI
# - Design Decision #1598
# -
locals {
  msi_enabled_virtual_machine_scalesets = [
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    vmss_v if coalesce(lookup(vmss_v, "assign_identity"), false) == true
  ]

  vmss_principal_ids = flatten([
    for x in azurerm_windows_virtual_machine_scale_set.this :
    [
      for y in x.identity :
      y.principal_id if y.principal_id != ""
    ] if length(keys(azurerm_windows_virtual_machine_scale_set.this)) > 0
  ])
}

resource "azurerm_key_vault_access_policy" "this" {
  count        = length(local.msi_enabled_virtual_machine_scalesets) > 0 ? length(local.vmss_principal_ids) : 0
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = element(local.vmss_principal_ids, count.index)

  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions

  depends_on = [azurerm_windows_virtual_machine_scale_set.this]
}

#####################################################
# Windows VMSS CMK and Disk Encryption Set
#####################################################
locals {
  cmk_enabled_virtual_machine_scalesets = {
    for vmss_k, vmss_v in var.virtual_machine_scalesets :
    vmss_k => vmss_v if coalesce(lookup(vmss_v, "enable_cmk_disk_encryption"), false) == true
  }
}

# -
# - Generate CMK Key for Windows VMSS
# - Design Decision #1582, #1589
# -
resource "azurerm_key_vault_key" "this" {
  for_each     = local.cmk_enabled_virtual_machine_scalesets
  name         = each.value.name
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt", "encrypt", "sign",
    "unwrapKey", "verify", "wrapKey"
  ]
}

# -
# - Enable Disk Encryption Set for Windows VMSS using CMK
#  Design Decision #1580, #1589
# -
resource "azurerm_disk_encryption_set" "this" {
  for_each            = local.cmk_enabled_virtual_machine_scalesets
  name                = "${each.value.name}-des"
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  key_vault_key_id    = lookup(azurerm_key_vault_key.this, each.key)["id"]

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [key_vault_key_id]
  }

  tags = local.tags
}

# -
# - Adding Access Policies for Disk Encryption Set MSI
# - Design Decision #1589
# -
resource "azurerm_key_vault_access_policy" "cmk" {
  for_each     = local.cmk_enabled_virtual_machine_scalesets
  key_vault_id = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id

  tenant_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.tenant_id
  object_id = lookup(azurerm_disk_encryption_set.this, each.key).identity.0.principal_id

  key_permissions    = ["get", "wrapkey", "unwrapkey"]
  secret_permissions = ["get"]
}

# -
# - Enabling Auto Scale Setting for Virtual Machine Scalesets
# -
locals {
  default_auto_scale_settings = {
    for k, v in var.virtual_machine_scalesets :
    k => {
      name = v.name
      id   = azurerm_windows_virtual_machine_scale_set.this[k].id
    } if coalesce(lookup(v, "enable_default_auto_scale_settings"), true) == true
  }
}

resource "azurerm_monitor_autoscale_setting" "default" {
  for_each            = local.default_auto_scale_settings
  name                = each.value.name
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  target_resource_id  = each.value.id

  profile {
    name = "defaultProfile"

    capacity {
      default = 2
      minimum = 2
      maximum = 4
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = each.value.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = "80"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = each.value.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 10
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}

# Custom Autoscale settings
resource "azurerm_monitor_autoscale_setting" "custom" {
  for_each            = var.custom_auto_scale_settings
  name                = each.value["name"]
  resource_group_name = local.resourcegroup_state_exists == true ? var.resource_group_name : data.azurerm_resource_group.this.0.name
  location            = local.resourcegroup_state_exists == true ? lookup(data.terraform_remote_state.resourcegroup.outputs.resource_group_locations_map, var.resource_group_name) : data.azurerm_resource_group.this.0.location
  target_resource_id  = lookup(azurerm_windows_virtual_machine_scale_set.this, each.value["vmss_key"])["id"]

  profile {
    name = each.value.profile_name

    capacity {
      default = each.value.default_instances
      minimum = each.value.minimum_instances
      maximum = each.value.maximum_instances
    }

    dynamic "rule" {
      for_each = coalesce(lookup(each.value, "rule"), [])
      content {
        metric_trigger {
          metric_name        = rule.value.metric_name
          metric_resource_id = lookup(azurerm_windows_virtual_machine_scale_set.this, each.value["vmss_key"])["id"]
          time_grain         = coalesce(lookup(rule.value, "time_grain"), "PT1M")
          statistic          = coalesce(lookup(rule.value, "statistic"), "Average")
          time_window        = coalesce(lookup(rule.value, "time_window"), "PT5M")
          time_aggregation   = coalesce(lookup(rule.value, "time_aggregation"), "Average")
          operator           = coalesce(lookup(rule.value, "operator"), "GreaterThan")
          threshold          = coalesce(lookup(rule.value, "threshold"), "threshold")
        }
        scale_action {
          direction = rule.value.direction
          type      = rule.value.type
          value     = rule.value.value
          cooldown  = rule.value.cooldown
        }
      }
    }
  }
}

######################################################
# Role Assignment
######################################################
# -
# - Assigning Reader Role to VMSS in order to access KV using MSI Identity
# -
resource "azurerm_role_assignment" "kv" {
  count                            = (var.kv_role_assignment == true && length(local.msi_enabled_virtual_machine_scalesets) > 0) ? length(local.vmss_principal_ids) : 0
  scope                            = local.keyvault_state_exists == true ? data.terraform_remote_state.keyvault.outputs.key_vault_id : data.azurerm_key_vault.this.0.id
  role_definition_name             = "Reader"
  principal_id                     = element(local.vmss_principal_ids, count.index)
  skip_service_principal_aad_check = true
}
