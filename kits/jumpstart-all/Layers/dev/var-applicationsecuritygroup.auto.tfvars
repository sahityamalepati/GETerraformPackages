resource_group_name = "jstart-all-dev-02012022"

application_security_groups = {
  asg1 = {
    name = "asg-src-1"
  },
  asg2 = {
    name = "asg-dest-1"
  }
}

app_security_groups_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}
