variable "resource_group_name" {
  type        = string
  description = "Specifies the Resource Group Name of Private DNS records."
}

variable "dns_records_additional_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default     = {}
}

# -
# - Private DNS A Records
# -
variable "dns_a_records" {
  type = map(object({
    a_record_name         = string
    dns_zone_name         = string
    ttl                   = number
    ip_addresses          = list(string)
    private_endpoint_name = string
  }))
  description = "Map containing Private DNS A Records Objects"
  default     = {}
}

# -
# - Private DNS CNAME Records
# -
variable "dns_cname_records" {
  type = map(object({
    cname_record_name = string
    dns_zone_name     = string
    ttl               = number
    record            = string
  }))
  description = "Map containing Private DNS CNAME Records Objects"
  default     = {}
}

# -
# - Private DNS SRV Records
# -
variable "dns_srv_records" {
  type = map(object({
    srv_record_name = string
    dns_zone_name   = string
    ttl             = number
    records = list(object({
      priority = number
      weight   = number
      port     = number
      target   = string
    }))
  }))
  description = "Map containing Private DNS SRV Records Objects"
  default     = {}
}

############################
# State File
############################ 
variable ackey {
  description = "Not required if MSI is used to authenticate to the SA where state file is"
  default     = null
}
