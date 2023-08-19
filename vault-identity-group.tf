resource "vault_identity_group" "identity-group" {

  for_each = { for v in local.identity_groups_list : v.group_id => v }

  name     = each.key
  type     = each.value.type
  policies = each.value.policies
  metadata = each.value.metadata
}

resource "vault_identity_group_alias" "identity-group-alias" {

  for_each = { for v in local.identity_groups_list : v.group_id => v }

  name           = each.key
  mount_accessor = each.value.mount_type == "jwt" || each.value.mount_type == "oidc" ? vault_jwt_auth_backend.jwt[each.value.mount_path].accessor : each.value.mount_type == "kubernetes" ? vault_auth_backend.kubernetes[each.value.mount_path].accessor : vault_auth_backend.auth_backend[each.value.mount_type].accessor
  canonical_id   = vault_identity_group.identity-group[each.key].id
}
