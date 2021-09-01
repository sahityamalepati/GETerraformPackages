resource_group_name = "jstart-all-dev-02012022"

shared_image_galleries = {
  sig1 = {
    name        = "jstartall02012022sig"
    description = "jstartallsigdesc"
  }
}

sig_additional_tags = {
  iac          = "Terraform"
  env          = "uat"
  automated_by = ""
}