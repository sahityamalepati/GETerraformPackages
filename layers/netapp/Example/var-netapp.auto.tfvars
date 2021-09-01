# NetApp register provider
# https://docs.microsoft.com/en-us/azure/azure-netapp-files/azure-netapp-files-register
# Contacts: Tyler Hoffman b-tyhoff@microsoft.com AND Steve Novosel b-stnovo@microsoft.com

resource_group_name = "jstart-all-dev-01212021"

netapp_location = null
existing_netapp_account = null
existing_netapp_account_rg_name = null
netapp_account = "account1"


netapp_pools = {
  pool1 = {
    pool_name     = "pool1"
    service_level = "Premium"
    size_in_tb    = 20
  },
  pool2 = {
    pool_name     = "pool2"
    service_level = "Premium"
    size_in_tb    = 27
  },
  pool3 = {
    pool_name     = "pool3"
    service_level = "Premium"
    size_in_tb    = 5
  }
}

netapp_volumes = {
  volume1 = {
    pool_key            = "pool1"
    name                = "p1v1"
    volume_path         = "p1v1"
    service_level       = "Premium"
    subnet_name         = "NetAppSubnet"
    vnet_name                      = "jstartvmssfirst"           #null if looking up from the statefile
    networking_resource_group      = "jstart-all-dev-01212021"   #null if looking up from the statefile
    storage_quota_in_gb = 100
    protocols           = ["NFSv3"]
    export_policy_rules = [
      {
        allowed_clients = ["10.155.118.20"]
        nfsv3_enabled   = true
        unix_read_write = true
      },
      {
        allowed_clients = ["10.155.117.17"]
        nfsv3_enabled   = true
        unix_read_write = true
      }
    ]
  }
}

netapp_snapshot_policies = {
  policy1 = {
    name = "policy1"
    snapshotPolicyName="policy1"
    hourlySnapshots=0
    dailySnapshots=0
    monthlySnapshots=10
    monthlydays=5
    monthlyhour=0
    monthlyminute=0
    weeklySnapshots=0
    enabled=true
    delpolicy=1
  }
}

netapp_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}