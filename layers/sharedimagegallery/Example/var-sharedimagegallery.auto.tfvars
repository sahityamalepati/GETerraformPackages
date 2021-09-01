resource_group_name = "jstart-all-dev-10022020"

shared_image_galleries = {
  sig1 = {
    name        = "jstartall10022020sig"
    description = "jstartallsigdesc"
  }
}

sig_additional_tags = {
  iac = "Terraform"
  env = "UAT"
}