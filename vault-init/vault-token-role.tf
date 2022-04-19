# Vault token role
resource "vault_token_auth_backend_role" "roles" {
  for_each = { for i in local.vault_token_roles_list : "${i.role_name}" => i
  }

  role_name              = each.key
  allowed_policies       = each.value.allowed_policies
  disallowed_policies    = each.value.disallowed_policies
  orphan                 = each.value.orphan
  renewable              = each.value.renewable
  path_suffix            = each.value.path_suffix
  token_period           = each.value.token_period
  token_ttl              = each.value.token_ttl
  token_max_ttl          = each.value.token_max_ttl
  token_explicit_max_ttl = each.value.token_explicit_max_ttl

}
