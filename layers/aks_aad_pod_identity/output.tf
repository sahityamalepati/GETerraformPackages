# #############################################################################
# # OUTPUTS AAD POD IDENTITIES
# #############################################################################

output "identities" {
    value = var.identities
    # secret = true
    depends_on = [helm_release.aad_pod_identity]
}