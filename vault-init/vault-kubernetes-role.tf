# Kubernetes roles for secret injections
resource "vault_kubernetes_auth_backend_role" "kubernetes" {

  for_each = {
    for k, v in local.kubernetes_auth_backends : "${v.path}_${v.role_name}" => v
  }

  backend                          = vault_auth_backend.kubernetes[each.value.path].path
  role_name                        = each.value.role_name
  bound_service_account_names      = each.value.bound_service_account_names
  bound_service_account_namespaces = each.value.bound_service_account_namespaces
  token_policies                   = each.value.token_policies
}
