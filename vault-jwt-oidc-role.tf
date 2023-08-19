# JWT roles for deploy services
resource "vault_jwt_auth_backend_role" "roles" {

  for_each = { for v in local.jwt_oidc_roles_list : v.path => v }

  role_name             = each.value.name
  backend               = vault_jwt_auth_backend.jwt[each.value.path].path
  role_type             = each.value.type
  user_claim            = each.value.user_claim
  bound_claims          = each.value.bound_claims
  bound_audiences       = each.value.bound_audiences
  bound_subject         = each.value.bound_subject
  bound_claims_type     = each.value.bound_claims_type
  claim_mappings        = each.value.claim_mappings
  oidc_scopes           = each.value.oidc_scopes
  groups_claim          = each.value.groups_claim
  allowed_redirect_uris = each.value.allowed_redirect_uris
  clock_skew_leeway     = each.value.clock_skew_leeway
  expiration_leeway     = each.value.expiration_leeway
  not_before_leeway     = each.value.not_before_leeway
  verbose_oidc_logging  = each.value.verbose_oidc_logging

  token_ttl               = each.value.token_ttl
  token_max_ttl           = each.value.token_max_ttl
  token_period            = each.value.token_period
  token_policies          = each.value.token_policies
  token_bound_cidrs       = each.value.token_bound_cidrs
  token_explicit_max_ttl  = each.value.token_explicit_max_ttl
  token_no_default_policy = each.value.token_no_default_policy
  token_num_uses          = each.value.token_num_uses
  token_type              = each.value.token_type
}
