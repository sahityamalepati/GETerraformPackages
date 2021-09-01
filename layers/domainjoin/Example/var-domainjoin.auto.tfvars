resource_group_name = "MSSMS-EASTUS2-NPRD-7310-INFRA01-RG"

key_vault_name            = "dj-e2-prod-mgmt-kv02"
key_vault_rg_name         = "ActiveDirectory"
key_vault_subscription_id = "0cf4464d-8020-4909-8f19-a0b886ca07df"

domain_join_extensions = {
  dj1 = {
    secret_name          = "ITServices-Current1"
    virtual_machine_name = "Wjske2001"
  }
}

