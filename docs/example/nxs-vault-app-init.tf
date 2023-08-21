module "vault-init" {
  source = "github.com/nixys/nxs-vault-app-init"

  output_files_path = "./files"

  vault_addr            = "https://127.0.0.1:8200"
  vault_admin_token     = "token"
  vault_skip_tls_verify = true

  policies = [
    {
      name         = "policy-1"
      paths        = ["kv-1", "kv-1/*"]
      capabilities = ["create", "read", "update", "list"]
    },
    {
      name         = "policy-2"
      paths        = ["kv-2", "kv-2/*"]
      capabilities = ["read", "list"]
    }
  ]

  secrets_engines = [
    {
      path = "kv-1"
      type = "kv"
      options = {
        version = "2"
      }
    },
    {
      path = "kv-2"
      type = "kv-v2"
    }
  ]

  auth_backends = [
    {
      type = "cert"
      path = "cert"
    }
  ]

  jwt_oidc_auth_backend = [
    {
      path         = "gitlab_jwt"
      type         = "jwt"
      jwks_url     = "https://gitlab.example.com/-/jwks/"
      bound_issuer = "gitlab.example.com"
    },
    {
      path               = "oidc"
      type               = "oidc"
      oidc_discovery_url = "https://login.microsoftonline.com/12324436534/v2.0"
      oidc_client_id     = "123"
      oidc_client_secret = "secret"
      default_role       = "azure_users"
    },
    {
      type                   = "jwt"
      path                   = "jwt-pubkeys"
      jwt_validation_pubkeys = ["jwt-keys-1", "jwt-keys-2"]
      tune = {
        default_lease_ttl = "10m"
        max_lease_ttl     = "10m"
      }
    }
  ]

  certs_auth_backend = [
    {
      name     = "cert1"
      policies = ["policy-1"]
      path     = "cert"
      tls_self_signed_cert = {
        common_name       = "Cert1"
        organization      = "Organization1"
        allowed_uses      = ["key_encipherment", "digital_signature", "server_auth", "client_auth", "cert_signing"]
        convert_to_pkcs12 = true
      }
    }
  ]

  kubernetes_auth_backends = [
    {
      path               = "kubernetes"
      kubernetes_host    = "https://example.com"
      kubernetes_ca_cert = "-----BEGIN CERTIFICATE-----\nexample\n-----END CERTIFICATE-----"
      token_reviewer_jwt = "ZXhhbXBsZQo="
      issuer             = "kubernetes.io/serviceaccount"
      roles = [
        {
          role_name                        = "role1"
          bound_service_account_names      = ["deployer"]
          bound_service_account_namespaces = ["*"]
          token_policies                   = ["policy-1"]
        },
        {
          role_name                        = "role2"
          bound_service_account_names      = ["*"]
          bound_service_account_namespaces = ["test"]
          token_policies                   = ["policy-2"]
        }
      ]
      tune = {
        max_lease_ttl = "90000s"
      }
    }
  ]

  vault_tokens = [
    {
      policies     = ["policy-1"]
      display_name = "token-1"
      role_name    = "role-1"
    }
  ]

  vault_token_roles = [
    {
      role_name        = "role-1"
      allowed_policies = ["policy-1"]
    }
  ]

  jwt_oidc_roles = [
    {
      name           = "jwt-1"
      path           = "gitlab_jwt"
      type           = "jwt"
      token_policies = ["policy-1"]
      user_claim     = "user_email"
      bound_claims   = { "project_id" : "111" }
    },
  ]

  identity_groups = [
    {
      group_id = "23454355467"
      type     = "external"
      policies = ["policy-1"]
      metadata = {
        responsibility = "kv-1"
      }
      mount_type = "oidc"
      mount_path = "oidc"
    }
  ]

}