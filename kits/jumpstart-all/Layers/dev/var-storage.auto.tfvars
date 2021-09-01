resource_group_name = "jstart-all-dev-02012022"

storage_accounts = {
  sa1 = {
    name                     = "jstartall02012022sa"
    sku                      = "Standard_LRS"
    account_kind             = null
    access_tier              = null
    assign_identity          = true
    cmk_enable               = true
    min_tls_version          = "TLS1_2"
    large_file_share_enabled = true
    network_rules = {
      bypass                     = ["None"]
      default_action             = "Allow"
      ip_rules                   = null
      virtual_network_subnet_ids = null
    }
  }
}

key_vault_name = null #"jstartall02012022kv"

sa_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
  pe_enable    = true
}