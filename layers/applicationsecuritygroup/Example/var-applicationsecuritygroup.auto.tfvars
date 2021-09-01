resource_group_name = "jstart-vmss-layered07142020"

application_security_groups = {
  asg1 = {
    name = "asg-src"
  },
  asg2 = {
    name = "asg-dest"
  }
}

app_security_groups_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}
