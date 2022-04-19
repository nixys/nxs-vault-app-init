# Policies for deploy services
resource "vault_policy" "policy" {
  for_each = { for i in local.policies_list : "${i.name}" => i
  }
  name = each.key

  policy = join("\n", each.value.value)
}
