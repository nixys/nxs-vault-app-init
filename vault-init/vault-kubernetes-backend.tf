# Kubernetes Backend
resource "vault_auth_backend" "kubernetes" {

  for_each = { for i in local.kubernetes_auth_backends_list : i.path => i }

  type = "kubernetes"
  path = each.key

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

resource "vault_kubernetes_auth_backend_config" "kubernetes" {

  for_each = { for i in local.kubernetes_auth_backends_list : i.path => i }

  backend            = vault_auth_backend.kubernetes[each.key].path
  kubernetes_host    = each.value.kubernetes_host
  kubernetes_ca_cert = each.value.kubernetes_ca_cert
  token_reviewer_jwt = each.value.token_reviewer_jwt
  issuer             = each.value.issuer
}
