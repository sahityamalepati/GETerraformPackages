role_definitions = {
  role_network_peer = {
    name        = "Role Name"
    description = "Role Description"
    scope       = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
    actions     = [
      "Microsoft.Network/virtualNetworks/read"
    ]
    not_actions = []
    assignable_scopes = ["/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"]
  }
}

role_assignments = {
  role_network_peer = {
    scope                = "/subscriptions/xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
    role_definition_name = "Role Name"
    principal_id         = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx"
  }
}
