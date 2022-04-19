# Secrets engines for deploy services
resource "vault_mount" "secrets_engines" {

  for_each = { for e in local.secrets_engines_list : e.path => e }

  path = each.key
  type = each.value.type

  options = each.value.options
}

