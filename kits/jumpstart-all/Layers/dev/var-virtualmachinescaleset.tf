locals {
  linux_image_ids = {
    "jstartvmss001" = var.todoapp_image_id
  }
}

# Diagnostics Extensions
variable "todoapp_image_id" {
  type        = string
  description = "The image id"
  default     = null
}
