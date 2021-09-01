resource "time_static" "timestamp" {}

locals {
  common_tags = merge(
    var.common_tags,
    {
      last_modified = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
      created       = formatdate("DD MMM YYYY hh:mm ZZZ", time_static.timestamp.rfc3339)
      created_by    = var.userID
      automated_by  = "ge-onboarding-devops-services"
      appid       = var.appid
      env           = "nprd"
    }
  )

  common_vars = {
    tags            = local.common_tags
    region          = var.region
    appid         = var.appid
    name_prefix     = "${var.appid}-${var.region}"
    subscription_id = var.subscription_id
  }
  azdo_settings = {
      admin_username = var.vm_admin_username
      admin_password = var.vm_admin_password
  }

  default_vmss_agent_pools = {
    pool1 = {
        name                = "adoagent" # DO NOT CHANGE
        resource_group_name = "devops" # DO NOT CHANGE
        pool_name           = "${var.appid}agents" # name of the agent pool you created. it must match exactly
        sku                 = "Standard_B2ms" #adjust if you want a difference size of VM
        instances           = 0 # adjust to the number of agents you want to deploy
        snet_key            = "agent_pool" # DO NOT CHANGE
      }
  }
  vmss_agent_pools = var.vmss_agent_pools != null ? var.vmss_agent_pools : local.default_vmss_agent_pools 

  default_sig = {
    sig1 = {
      name                = "devopssig"
      resource_group_name = "devops"
      region              = var.region
    }
  }
  shared_image_galleries = var.deploy_sig ? local.default_sig : {} 

}
