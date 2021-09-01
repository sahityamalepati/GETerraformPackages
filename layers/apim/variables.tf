variable "resource_group_name" {
  type = string
}

variable "api_management" {
  type = map(object({
    name                 = string
    publisher_name       = string
    publisher_email      = string
    virtual_network_type = string
    subnet_name          = string
    sku_name             = string
  }))
}


variable "apimgmtdemo" {
  type = map(object({
    name         = string
    apim_key     = string
    revision     = string
    display_name = string
    path         = string
    protocols    = list(string)
    import = object({
      content_format = string
      content_value  = string
    })
  }))
}
