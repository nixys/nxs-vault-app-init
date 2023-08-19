# Vault tokens
resource "vault_token" "tokens" {
  for_each = { for i in local.vault_tokens_list : "${i.display_name}" => i
  }

  display_name     = each.key
  policies         = each.value.policies
  role_name        = each.value.role_name
  renewable        = each.value.renewable
  ttl              = each.value.ttl
  explicit_max_ttl = each.value.explicit_max_ttl
  period           = each.value.period
  renew_min_lease  = each.value.renew_min_lease
  renew_increment  = each.value.renew_increment

  depends_on = [
    vault_token_auth_backend_role.roles,
  ]
}
