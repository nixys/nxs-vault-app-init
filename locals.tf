locals {
  secrets_engines_list = [for i in var.secrets_engines :
    merge(
      var.default_secrets_engines,
      i,
    )
  ]

  policies_list = flatten([for k in var.policies : {
    name = k.name
    value = [for v in k.paths :
      <<-EOF
        path "${v}" {
          capabilities = ${local.capabilities_string["${k.name}"]}
        }
        EOF
    ] }
  ])

  capabilities_string = { for k in var.policies :
    k.name => "[${join(", ", [for s in k.capabilities : format("%q", s)])}]"
  }

  auth_backends_list = [for i in var.auth_backends :
    merge(
      var.default_auth_backends,
      i,
    )
  ]

  jwt_oidc_auth_backend_list = [for i in var.jwt_oidc_auth_backend :
    merge(
      var.default_jwt_oidc_auth_backend,
      i,
    )
  ]

  certs_auth_backend_list = [for i in var.certs_auth_backend :
    merge(
      var.default_certs_auth_backend,
      i,
    )
  ]

  kubernetes_auth_backends_list = [for i in var.kubernetes_auth_backends :
    merge(
      var.default_kubernetes_auth_backends,
      i,
    )
  ]

  kubernetes_auth_backends = flatten([for i in local.kubernetes_auth_backends_list : [for j in i.roles : {
    path                             = i.path
    role_name                        = j.role_name
    bound_service_account_names      = j.bound_service_account_names
    bound_service_account_namespaces = j.bound_service_account_namespaces
    token_policies                   = try(j.token_policies, null)
    }
  ]])

  vault_tokens_list = [for i in var.vault_tokens :
    merge(
      var.default_vault_tokens,
      i,
    )
  ]

  vault_token_roles_list = [for i in var.vault_token_roles :
    merge(
      var.default_vault_token_roles,
      i,
    )
  ]

  jwt_oidc_roles_list = [for i in var.jwt_oidc_roles :
    merge(
      var.default_jwt_oidc_roles,
      i,
    )
  ]

  identity_groups_list = [for i in var.identity_groups :
    merge(
      var.default_identity_groups,
      i,
    )
  ]

  jwt_validation_pubkeys_list = toset(flatten([for i in var.jwt_oidc_auth_backend : [for j in try(i.jwt_validation_pubkeys, []) : j]]))
}

