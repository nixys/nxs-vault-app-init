output "pkcs12_password" {

  description = "P12 cert password"
  value       = module.vault-init.pkcs12_password
  sensitive   = true
}

output "vault_tokens" {

  description = "Vault tokens list"
  value       = module.vault-init.vault_tokens
  sensitive   = true
}
