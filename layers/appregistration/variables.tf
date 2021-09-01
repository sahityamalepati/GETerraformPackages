variable "application_names" {
    type        = map(object({
        name                        = string
        available_to_other_tenants  = bool
        oauth2_allow_implicit_flow  = bool
    }))
}