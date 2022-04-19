# Create self signed cert for auth

resource "tls_private_key" "tls_key" {

  for_each = { for i in local.certs_auth_backend_list : i.name => i }

  algorithm = "RSA"
  rsa_bits  = "2048"
}

resource "tls_self_signed_cert" "tls_cert" {

  for_each = { for i in local.certs_auth_backend_list : i.name => i }

  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.tls_key[each.key].private_key_pem

  subject {
    common_name  = lookup(each.value.tls_self_signed_cert, "common_name", null)
    organization = lookup(each.value.tls_self_signed_cert, "organization", null)
  }

  validity_period_hours = 876600

  allowed_uses = each.value.tls_self_signed_cert.allowed_uses
}

resource "local_file" "cert_private_key" {

  for_each = tls_private_key.tls_key

  content  = each.value.private_key_pem
  filename = "${var.output_files_path}/certs/${each.key}/private_key"
}

resource "local_file" "cert_public_key" {

  for_each = tls_self_signed_cert.tls_cert
  content  = each.value.cert_pem
  filename = "${var.output_files_path}/certs/${each.key}/public_key"
}

# Create p12
resource "pkcs12_from_pem" "pkcs12" {

  for_each = { for i in local.certs_auth_backend_list : i.name => i if try(i.tls_self_signed_cert.convert_to_pkcs12, false) == true }

  password        = random_password.pkcs12[each.key].result
  cert_pem        = tls_self_signed_cert.tls_cert[each.key].cert_pem
  private_key_pem = tls_private_key.tls_key[each.key].private_key_pem
}

resource "local_file" "pkcs12" {

  for_each = { for i in local.certs_auth_backend_list : i.name => i if try(i.tls_self_signed_cert.convert_to_pkcs12, false) == true }

  filename       = "${var.output_files_path}/certs/${each.key}/pkcs12/certificates.p12"
  content_base64 = pkcs12_from_pem.pkcs12[each.key].result
}

# Add cert to Vault
resource "vault_generic_endpoint" "cert" {
  depends_on = [vault_auth_backend.auth_backend, tls_self_signed_cert.tls_cert]

  for_each = { for i in local.certs_auth_backend_list : i.name => i }

  path                 = "auth/${each.value.path}/certs/${each.value.name}"
  ignore_absent_fields = true

  data_json = jsonencode({
    "display_name" : "${each.value.name}",
    "policies" : each.value.policies,
    "certificate" : tls_self_signed_cert.tls_cert[each.key].cert_pem
  })
}
