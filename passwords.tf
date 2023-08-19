### Generate password for pkcs12
resource "random_password" "pkcs12" {

  for_each = { for i in local.certs_auth_backend_list : i.name => i if try(i.tls_self_signed_cert.convert_to_pkcs12, false) == true }

  length           = 16
  special          = true
  override_special = "_@"
}
