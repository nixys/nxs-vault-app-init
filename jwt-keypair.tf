resource "tls_private_key" "jwt_keypair" {

  for_each = local.jwt_validation_pubkeys_list

  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "private_key" {

  for_each = tls_private_key.jwt_keypair

  content  = each.value.private_key_pem
  filename = "${var.output_files_path}/jwt/${each.key}/private_key"
}

resource "local_file" "public_key" {

  for_each = tls_private_key.jwt_keypair
  content  = each.value.public_key_pem
  filename = "${var.output_files_path}/jwt/${each.key}/public_key"
}
