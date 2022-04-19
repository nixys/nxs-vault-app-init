#==================== Files ==================== #
variable "output_files_path" {
  description = "Path where save tls certs and jwt keys."
  default     = "./files"
  type        = string
}

#==================== Vault init ====================#
variable "vault_addr" {
  description = "Vault addres"
  type        = string
}

variable "vault_admin_token" {
  description = "Vault admin token"
  type        = string
}

variable "vault_skip_tls_verify" {
  description = "Set this to true to disable verification of the Vault server's TLS certificate"
  type        = string
  default     = false
}

variable "policies" {
  description = "List of policies for create"
  type = list(object(
    {
      name         = string
      paths        = list(string)
      capabilities = list(string)
    }
    )
  )
}

variable "secrets_engines" {
  description = "List of secrets engines for create"
  type        = any

  validation {
    condition     = alltrue([for i in var.secrets_engines : anytrue([length(lookup(i, "path", [])) > 0 ? true : false])])
    error_message = "\"path\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.secrets_engines : anytrue([length(lookup(i, "type", [])) > 0 ? true : false])])
    error_message = "\"type\" must be set!"
  }
}

variable "default_secrets_engines" {
  description = "Defautl values for secrets_engines"
  type = object(
    {
      path    = string
      type    = string
      options = map(any)
  })
  default = {
    path    = null
    type    = null
    options = {}
  }
}

variable "auth_backends" {
  description = "List of enabled auth backends"
  type        = any

  validation {
    condition     = alltrue([for i in var.auth_backends : anytrue([length(lookup(i, "type", [])) > 0 ? true : false])])
    error_message = "\"type\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.auth_backends : anytrue([lookup(i, "type", "") == "kubernetes" ? false : true])])
    error_message = "\"type\" must not be equal to \"kubernetes\". See for \"kubernetes_auth_backends\" variable!"
  }

  validation {
    condition     = alltrue([for i in var.auth_backends : anytrue([lookup(i, "type", "") == "jwt" ? false : true])])
    error_message = "\"type\" must not be equal to \"jwt\". See for \"jwt_oidc_auth_backend\" variable!"
  }

  validation {
    condition     = alltrue([for i in var.auth_backends : anytrue([lookup(i, "type", "") == "oidc" ? false : true])])
    error_message = "\"type\" must not be equal to \"oidc\". See for \"jwt_oidc_auth_backend\" variable!"
  }
}

variable "default_auth_backends" {
  description = "Defautl values for auth_backends"
  type = object(
    {
      type = string
      path = string
      tune = map(any)
  })
  default = {
    type = null
    path = null
    tune = {}
  }
}

variable "jwt_oidc_auth_backend" {
  description = "List of jwt/oidc auth backends"
  type        = any

  validation {
    condition     = alltrue([for i in var.jwt_oidc_auth_backend : anytrue([length(lookup(i, "path", [])) > 0 ? true : false])])
    error_message = "\"path\" must be set!"
  }
}

variable "default_jwt_oidc_auth_backend" {
  description = "Defautl values for jwt_oidc_auth_backend"
  type = object(
    {
      path                   = string
      type                   = string
      oidc_discovery_url     = string
      oidc_discovery_ca_pem  = string
      oidc_client_id         = string
      oidc_client_secret     = string
      oidc_response_mode     = string
      oidc_response_types    = list(string)
      jwks_url               = string
      jwks_ca_pem            = string
      jwt_validation_pubkeys = list(string)
      bound_issuer           = string
      jwt_supported_algs     = list(string)
      default_role           = string
      provider_config        = map(any)
      local                  = bool
      namespace_in_state     = string
      tune                   = map(any)
  })
  default = {
    path                   = null
    type                   = "jwt"
    oidc_discovery_url     = null
    oidc_discovery_ca_pem  = null
    oidc_client_id         = null
    oidc_client_secret     = null
    oidc_response_mode     = null
    oidc_response_types    = null
    jwks_url               = null
    jwks_ca_pem            = null
    jwt_validation_pubkeys = null
    bound_issuer           = null
    jwt_supported_algs     = null
    default_role           = null
    provider_config        = {}
    local                  = null
    namespace_in_state     = null
    tune                   = {}
  }
}

variable "certs_auth_backend" {
  description = "List of cert auth backends"
  type        = any

  validation {
    condition     = alltrue([for i in var.certs_auth_backend : anytrue([length(lookup(i, "name", [])) > 0 ? true : false])])
    error_message = "\"name\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.certs_auth_backend : anytrue([length(lookup(i.tls_self_signed_cert, "allowed_uses", [])) > 0 ? true : false])])
    error_message = "\"tls_self_signed_cert.allowed_uses\" must be set!"
  }
}

variable "default_certs_auth_backend" {
  description = "Defautl values for certs_auth_backend"
  type = object(
    {
      name     = string
      policies = list(string)
      path     = string
      tls_self_signed_cert = object({
        common_name       = string
        organization      = string
        allowed_uses      = list(string)
        convert_to_pkcs12 = bool
      })
    }
  )
  default = {
    name     = null
    policies = null
    path     = "cert"
    tls_self_signed_cert = {
      common_name       = null
      organization      = null
      allowed_uses      = null
      convert_to_pkcs12 = false
    }
  }
}

variable "kubernetes_auth_backends" {
  description = "List of kubernetes auth backends"
  type        = any

  validation {
    condition     = alltrue([for i in var.kubernetes_auth_backends : anytrue([length(lookup(i, "kubernetes_host", [])) > 0 ? true : false])])
    error_message = "\"kubernetes_host\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.kubernetes_auth_backends : alltrue([for j in i.roles : anytrue([length(lookup(j, "role_name", [])) > 0 ? true : false])])])
    error_message = "\"roles[].role_name.\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.kubernetes_auth_backends : alltrue([for j in i.roles : anytrue([length(lookup(j, "bound_service_account_names", [])) > 0 ? true : false])])])
    error_message = "\"roles[].bound_service_account_names.\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.kubernetes_auth_backends : alltrue([for j in i.roles : anytrue([length(lookup(j, "bound_service_account_namespaces", [])) > 0 ? true : false])])])
    error_message = "\"roles[].bound_service_account_namespaces.\" must be set!"
  }
}

variable "default_kubernetes_auth_backends" {
  description = "Defautl values for kubernetes_auth_backends"
  type = object(
    {
      path               = string
      kubernetes_host    = string
      kubernetes_ca_cert = string
      token_reviewer_jwt = string
      issuer             = string
      roles = list(object({
        role_name                        = string
        bound_service_account_names      = list(string)
        bound_service_account_namespaces = list(string)
        token_policies                   = list(string)
      }))
      tune = any
    }
  )
  default = {
    issuer             = null
    kubernetes_ca_cert = null
    kubernetes_host    = null
    path               = "kubernetes"
    roles              = []
    token_reviewer_jwt = null
    tune               = null
  }
}

variable "vault_tokens" {
  description = "List of vault tokens"
  type        = any

  validation {
    condition     = alltrue([for i in var.vault_tokens : anytrue([length(lookup(i, "policies", [])) > 0 ? true : false])])
    error_message = "\"policies\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.vault_tokens : anytrue([length(lookup(i, "display_name", [])) > 0 ? true : false])])
    error_message = "\"display_name\" must be set!"
  }
}

variable "default_vault_tokens" {
  description = "Defautl values for vault_tokens"
  type = object(
    {
      policies         = list(string)
      renewable        = bool
      ttl              = string
      explicit_max_ttl = string
      display_name     = string
      period           = string
      renew_min_lease  = string
      renew_increment  = string
      role_name        = string
  })
  default = {
    policies         = null
    renewable        = null
    ttl              = null
    explicit_max_ttl = null
    display_name     = null
    period           = null
    renew_min_lease  = null
    renew_increment  = null
    role_name        = null
  }
}

variable "vault_token_roles" {
  description = "List of vault token roles"
  type        = any

  validation {
    condition     = alltrue([for i in var.vault_token_roles : anytrue([length(lookup(i, "role_name", [])) > 0 ? true : false])])
    error_message = "\"role_name\" must be set!"
  }
}

variable "default_vault_token_roles" {
  description = "Defautl values for vault_token_roles"
  type = object(
    {
      role_name              = string
      allowed_policies       = list(string)
      disallowed_policies    = list(string)
      orphan                 = bool
      renewable              = bool
      path_suffix            = string
      token_period           = string
      token_ttl              = string
      token_max_ttl          = string
      token_explicit_max_ttl = string
  })
  default = {
    role_name              = null
    allowed_policies       = null
    disallowed_policies    = null
    orphan                 = null
    renewable              = null
    path_suffix            = null
    token_period           = null
    token_ttl              = null
    token_max_ttl          = null
    token_explicit_max_ttl = null
  }
}

variable "jwt_oidc_roles" {
  description = "List jwt or oidc roles"
  type        = any

  validation {
    condition     = alltrue([for i in var.jwt_oidc_roles : anytrue([length(lookup(i, "user_claim", [])) > 0 ? true : false])])
    error_message = "\"user_claim\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.jwt_oidc_roles : anytrue([length(lookup(i, "path", [])) > 0 ? true : false])])
    error_message = "\"path\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.jwt_oidc_roles : anytrue([length(lookup(i, "name", [])) > 0 ? true : false])])
    error_message = "\"name\" must be set!"
  }
}

variable "default_jwt_oidc_roles" {
  description = "Defautl values for jwt_oidc_roles"
  type = object(
    {
      name                  = string
      path                  = string
      type                  = string
      user_claim            = string
      bound_claims          = map(any)
      bound_audiences       = list(string)
      bound_subject         = string
      bound_claims_type     = any
      claim_mappings        = map(any)
      oidc_scopes           = list(string)
      groups_claim          = string
      allowed_redirect_uris = list(string)
      clock_skew_leeway     = string
      expiration_leeway     = string
      not_before_leeway     = string
      verbose_oidc_logging  = string

      token_ttl               = string
      token_max_ttl           = string
      token_period            = string
      token_policies          = list(string)
      token_bound_cidrs       = list(string)
      token_explicit_max_ttl  = string
      token_no_default_policy = bool
      token_num_uses          = string
      token_type              = string
  })
  default = {
    name                  = null
    path                  = null
    type                  = null
    user_claim            = null
    bound_claims          = {}
    bound_audiences       = null
    bound_subject         = null
    bound_claims_type     = null
    claim_mappings        = {}
    oidc_scopes           = null
    groups_claim          = null
    allowed_redirect_uris = null
    clock_skew_leeway     = null
    expiration_leeway     = null
    not_before_leeway     = null
    verbose_oidc_logging  = null

    token_ttl               = null
    token_max_ttl           = null
    token_period            = null
    token_policies          = null
    token_bound_cidrs       = null
    token_explicit_max_ttl  = null
    token_no_default_policy = null
    token_num_uses          = null
    token_type              = null
  }
}

variable "identity_groups" {
  description = "List of identity groups"
  type        = any

  validation {
    condition     = alltrue([for i in var.identity_groups : anytrue([length(lookup(i, "group_id", [])) > 0 ? true : false])])
    error_message = "\"group_id\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.identity_groups : anytrue([length(lookup(i, "mount_type", [])) > 0 ? true : false])])
    error_message = "\"mount_type\" must be set!"
  }

  validation {
    condition     = alltrue([for i in var.identity_groups : anytrue([length(lookup(i, "mount_path", [])) > 0 ? true : false])])
    error_message = "\"mount_path\" must be set!"
  }
}

variable "default_identity_groups" {
  description = "Defautl values for identity_groups"
  type = object({
    group_id   = string
    type       = string
    policies   = list(string)
    mount_type = string
    mount_path = string
    metadata   = map(any)
  })
  default = {
    group_id   = null
    metadata   = null
    mount_path = null
    mount_type = null
    policies   = null
    type       = null
  }
}
