# Auth backends
resource "vault_auth_backend" "auth_backend" {

  for_each = { for v in local.auth_backends_list : v.type => v }

  type = each.value.type
  path = each.value.path

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
