# -
# - Run script using null_resource
# -
resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "./Copy-Cert.ps1 -SubscriptionId ${var.subscription_id} -SourceVault ${var.source_vault} -DestinationVault ${var.destination_vault} -CertName (ConvertFrom-Json -InputObject '${jsonencode(var.cert_names)}')"
    interpreter = ["pwsh", "-Command"]
  }
}
