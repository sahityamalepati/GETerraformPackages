variable a_records {
  description = "A list of A Records to Create"
  type = map(object({
    a_rec_name    = string
    dns_zone_name = string
    ttl           = number
    ip_addresses  = list(string)
    rg_name       = string
  }))
}

variable "module_features" {}

resource "azurerm_private_dns_a_record" "a-records" {
  for_each            = var.module_features ? var.a_records : {}
  name                = each.value["a_rec_name"]
  zone_name           = each.value["dns_zone_name"]
  resource_group_name = each.value["rg_name"]
  ttl                 = each.value["ttl"]
  records             = each.value["ip_addresses"]
}


output "fqdns" {
  description = "A Map of FQDN of the DNS A Records"
  value       = { for a in azurerm_private_dns_a_record.a-records : a.name => a.fqdn }
}

output "ids" {
  value = { for a in azurerm_private_dns_a_record.a-records : a.name => a.id }
}
