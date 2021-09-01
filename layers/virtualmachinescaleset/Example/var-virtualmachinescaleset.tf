locals {
  linux_image_ids = {
    "test-vmss" = "/subscriptions/f28c99ba-3eac-470a-a3ee-fa026a3302d3/resourceGroups/gesos-prd/providers/Microsoft.Compute/galleries/gesos_image_central/images/GESOS-AZ-BASE-UBUNTU1804LTS"
  }
}

# Diagnostics Extensions
variable "todoapp_image_id" {
  type        = string
  description = "The image id"
  default     = null
}