# JWT/OIDC Backend
resource "vault_jwt_auth_backend" "jwt" {

  for_each = { for v in local.jwt_oidc_auth_backend_list : v.path => v }

  path                   = each.value.path
  type                   = each.value.type
  oidc_discovery_url     = each.value.oidc_discovery_url
  oidc_discovery_ca_pem  = each.value.oidc_discovery_ca_pem
  oidc_client_id         = each.value.oidc_client_id
  oidc_client_secret     = each.value.oidc_client_secret
  oidc_response_mode     = each.value.oidc_response_mode
  oidc_response_types    = each.value.oidc_response_types
  jwks_url               = each.value.jwks_url
  jwks_ca_pem            = each.value.jwks_ca_pem
  jwt_validation_pubkeys = length(coalesce(each.value.jwt_validation_pubkeys, [])) > 0 ? [for i in coalesce(each.value.jwt_validation_pubkeys, []) : "${tls_private_key.jwt_keypair[i].public_key_pem}"] : null
  bound_issuer           = each.value.bound_issuer
  jwt_supported_algs     = each.value.jwt_supported_algs
  default_role           = each.value.default_role
  provider_config        = each.value.provider_config
  local                  = each.value.local
  namespace_in_state     = each.value.namespace_in_state

  tune {
    default_lease_ttl            = lookup(each.value.tune, "default_lease_ttl", null)
    max_lease_ttl                = lookup(each.value.tune, "max_lease_ttl", null)
    audit_non_hmac_response_keys = lookup(each.value.tune, "audit_non_hmac_response_keys", null)
    audit_non_hmac_request_keys  = lookup(each.value.tune, "audit_non_hmac_request_keys", null)
    listing_visibility           = lookup(each.value.tune, "listing_visibility", null)
    passthrough_request_headers  = lookup(each.value.tune, "passthrough_request_headers", null)
    allowed_response_headers     = lookup(each.value.tune, "allowed_response_headers", null)
    token_type                   = lookup(each.value.tune, "token_type", null)
  }

}
