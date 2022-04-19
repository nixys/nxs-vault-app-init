output "pkcs12_password" {

  description = "P12 cert password"
  value = [for i in local.certs_auth_backend_list : {
    (i.name) = random_password.pkcs12[i.name].result
  } if try(i.tls_self_signed_cert.convert_to_pkcs12, false) == true]
  sensitive = true
}

output "vault_tokens" {

  description = "Vault tokens list"
  value = [for i in local.vault_tokens_list : {
    (i.display_name) = vault_token.tokens[i.display_name].client_token
  }]
  sensitive = true
}
