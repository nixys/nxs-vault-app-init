# nxs-vault-app-init

## Introduction

nxs-vault-app-init is a terraform module for Vault initalization.

### Features

- Create policies
- Create secrets engines
- Create auth backends (certs, jwt, oidc, kubernetes, etc)
- Create jwt/oidc roles and identity groups
- Generate tls certs and jwt keys in specific directory

### Who can use the tool

Developers and admins which work with different projects that use Vault.

## Quickstart

[Set up](#settings) the nxs-vault-app-init terraform file, then init and run module.

### Settings

| Variable | Required | Default value | Description |
|---       | :---:    | :---:         |---          |
| `output_files_path` | true | ./files | The path to directory where save generated tls certs and jwt keys |
| `vault_addr` | true | | Vault address |
| `vault_admin_token` | true | | Vault admin token |
| `vault_skip_tls_verify` | false | false | Set this to true to disable verification of the Vault server's TLS certificate |
| `policies` | true | | List of policies to create |
| `policies.name` | true | | Name of the policy |
| `policies.paths` | true | | List of paths for secrets engines |
| `policies.capabilities` | true | | List of capabilities for policy |
| `secrets_engines` | true | | List of secrets engines |
| `secrets_engines.path` | true | | Secret engine path |
| `secrets_engines.type` | true | | Secret engine type |
| `secrets_engines.options` | false | | Secret engine options |
| `auth_backends` | true | | List of auth backends |
| `auth_backends.type` | true | | Auth backend type |
| `auth_backends.path` | false | | Auth backend path. Default value equal to type |
| `auth_backends.tune` | false | | Auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune) |
| `jwt_oidc_auth_backend` | true | | List of jwt/oidc auth backends |
| `jwt_oidc_auth_backend.path` | true | | Auth backend path |
| `jwt_oidc_auth_backend.type` | false | jwt | Auth backend type |
| `jwt_oidc_auth_backend.oidc_discovery_url` | false | | the OIDC Discovery URL, without any .well-known component (base path). Cannot be used in combination with `jwt_validation_pubkeys` |
| `jwt_oidc_auth_backend.oidc_discovery_ca_pem` | false | | The CA certificate or chain of certificates, in PEM format, to use to validate connections to the OIDC Discovery URL. If not set, system certificates are used |
| `jwt_oidc_auth_backend.oidc_client_id` | false | | Client ID used for OIDC backends |
| `jwt_oidc_auth_backend.oidc_client_secret` | false | | Client Secret used for OIDC backends |
| `jwt_oidc_auth_backend.oidc_response_mode` | false | query | the response mode to be used in the OAuth2 request. Allowed values are "query" and "form_post". If using Vault namespaces, and `oidc_response_mode` is "form_post", then `namespace_in_state` should be set to "false" |
| `jwt_oidc_auth_backend.oidc_response_types` | false | ["code"] | List of response types to request. Allowed values are "code" and "id_token". Note: "id_token" may only be used if `oidc_response_mode` is set to form_post |
| `jwt_oidc_auth_backend.jwks_url` | false | | JWKS URL to use to authenticate signatures. Cannot be used with `oidc_discovery_url` or `jwt_validation_pubkeys` |
| `jwt_oidc_auth_backend.jwks_ca_pem` | false | | The CA certificate or chain of certificates, in PEM format, to use to validate connections to the JWKS URL. If not set, system certificates are used |
| `jwt_oidc_auth_backend.jwt_validation_pubkeys` | false | | A list of PEM-encoded public keys to use to authenticate signatures locally. Cannot be used in combination with `oidc_discovery_url` |
| `jwt_oidc_auth_backend.bound_issuer` | false | | The value against which to match the iss claim in a JWT |
| `jwt_oidc_auth_backend.jwt_supported_algs` | false | Vault 1.1.0 defaults to [RS256] but future or past versions of Vault may differ | A list of supported signing algorithms |
| `jwt_oidc_auth_backend.default_role` | false | | The default role to use if none is provided during login |
| `jwt_oidc_auth_backend.provider_config` | false | | provider specific handling configuration. All values may be strings, and the provider will convert to the appropriate type when configuring Vault |
| `jwt_oidc_auth_backend.local` | false | | Specifies if the auth method is local only |
| `jwt_oidc_auth_backend.namespace_in_state` | false | | pass namespace in the OIDC state parameter instead of as a separate query parameter. With this setting, the allowed redirect URL(s) in Vault and on the provider side should not contain a namespace query parameter. This means only one redirect URL entry needs to be maintained on the OIDC provider side for all vault namespaces that will be authenticating against it. Defaults to true for new configs |
| `jwt_oidc_auth_backend.tune` | false | | Auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune)|
| `certs_auth_backend` | true | | List of certs auth backends |
| `certs_auth_backend.name` | true | | Cert name |
| `certs_auth_backend.policies` | true | | List of policies |
| `certs_auth_backend.path` | false | cert | Certs auth backend path |
| `certs_auth_backend.tls_self_signed_cert` | true | | cert info |
| `certs_auth_backend.tls_self_signed_cert.common_name` | false | | Cert common name |
| `certs_auth_backend.tls_self_signed_cert.organization` | false | | Cert organization |
| `certs_auth_backend.tls_self_signed_cert.allowed_uses` | true | | List of [keywords](https://registry.terraform.io/providers/hashicorp/tls/3.2.1/docs/resources/self_signed_cert#allowed_uses) each describing a use that is permitted for the issued certificate |
| `certs_auth_backend.tls_self_signed_cert.convert_to_pkcs12` | false | false | Create or not pkcs12 cert |
| `kubernetes_auth_backends` | true | | List of kubernetes auth backends |
| `kubernetes_auth_backends.path` | false | kubernetes | Auth backend path |
| `kubernetes_auth_backends.kubernetes_host` | true | | Host must be a host string, a host:port pair, or a URL to the base of the Kubernetes API server |
| `kubernetes_auth_backends.kubernetes_ca_cert` | false | | PEM encoded CA cert for use by the TLS client used to talk with the Kubernetes API |
| `kubernetes_auth_backends.token_reviewer_jwt` | false | | A service account JWT used to access the TokenReview API to validate other JWTs during login. If not set the JWT used for login will be used to access the API |
| `kubernetes_auth_backends.issuer` | false | | JWT issuer |
| `kubernetes_auth_backends.roles` | false | | List of roles |
| `kubernetes_auth_backends.roles.role_name` | true | | Role name |
| `kubernetes_auth_backends.roles.bound_service_account_names` | true | | List of service account names able to access this role. If set to ["\*"] all names are allowed, both this and bound_service_account_namespaces can not be "\*" |
| `kubernetes_auth_backends.roles.bound_service_account_namespaces` | true | | List of namespaces allowed to access this role. If set to ["\*"] all namespaces are allowed, both this and bound_service_account_names can not be set to "\*" |
| `kubernetes_auth_backends.roles.token_policies` | false | | List of policies to encode onto generated tokens |
| `kubernetes_auth_backends.tune` | false | | Auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune) |
| `vault_tokens` | true | | List of vault tokens |
| `vault_tokens.display_name` | true | | Token display name |
| `vault_tokens.policies` | true | | Token policies |
| `vault_tokens.role_name` | false | | The token role name |
| `vault_tokens.renewable` | false | | Flag to allow to renew this token |
| `vault_tokens.ttl` | false | | The TTL period of this token |
| `vault_tokens.explicit_max_ttl` | false | | the explicit max TTL of this token |
| `vault_tokens.period` | false | | The period of this token |
| `vault_tokens.renew_min_lease` | false | | The minimal lease to renew this token |
| `vault_tokens.renew_increment` | false | | The renew increment |
| `vault_token_roles` | true | | List of vault token auth backend roles |
| `vault_token_roles.role_name` | true | | The name of the role |
| `vault_token_roles.allowed_policies` | false | | List of allowed policies for given role |
| `vault_token_roles.disallowed_policies` | false | | List of disallowed policies for given role |
| `vault_token_roles.orphan` | false | | If true, tokens created against this policy will be orphan tokens |
| `vault_token_roles.renewable` | false | | Whether to disable the ability of the token to be renewed past its initial TTL |
| `vault_token_roles.path_suffix` | false | | Tokens created against this role will have the given suffix as part of their path in addition to the role name |
| `vault_token_roles.token_period` | false | | If set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value. At each renewal, the token's TTL will be set to the value of this field. Specified in seconds |
| `vault_token_roles.token_ttl` | false | | the incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time |
| `vault_token_roles.token_max_ttl` | false | | The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time |
| `vault_token_roles.token_explicit_max_ttl` | false | | If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if `token_ttl` and `token_max_ttl` would otherwise allow a renewal |
| `jwt_oidc_roles` | true | | list of jwt/oidc roles |
| `jwt_oidc_roles.name` | true | | Role name |
| `jwt_oidc_roles.path` | true | | Auth backend path |
| `jwt_oidc_roles.type` | false | | Role type |
| `jwt_oidc_roles.user_claim` | true | | The claim to use to uniquely identify the user; this will be used as the name for the Identity entity alias created due to a successful login |
| `jwt_oidc_roles.bound_claims` | false | | If set, a map of claims to values to match against. A claim's value must be a string, which may contain one value or multiple comma-separated values, e.g. "red" or "red,green,blue" |
| `jwt_oidc_roles.bound_audiences` | false | | list of aud claims to match against. Any match is sufficient |
| `jwt_oidc_roles.bound_subject` | false | | If set, requires that the sub claim matches this value |
| `jwt_oidc_roles.bound_claims_type` | false | | How to interpret values in the claims/values map (bound_claims): can be either string (exact match) or glob (wildcard match). Requires Vault 1.4.0 or above |
| `jwt_oidc_roles.claim_mappings` | false | | If set, a map of claims (keys) to be copied to specified metadata fields (values) |
| `jwt_oidc_roles.oidc_scopes` | false | | If set, a list of OIDC scopes to be used with an OIDC role. The standard scope "openid" is automatically included and need not be specified |
| `jwt_oidc_roles.groups_claim` | false | | The claim to use to uniquely identify the set of groups to which the user belongs; this will be used as the names for the Identity group aliases created due to a successful login. The claim value must be a list of strings |
| `jwt_oidc_roles.allowed_redirect_uris` | false | | The list of allowed values for redirect_uri during OIDC logins. Required for OIDC roles |
| `jwt_oidc_roles.clock_skew_leeway` | false | 60 | The amount of leeway to add to all claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles |
| `jwt_oidc_roles.expiration_leeway` | false | 60 | The amount of leeway to add to expiration (exp) claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles |
| `jwt_oidc_roles.not_before_leeway` | false | 60 | The amount of leeway to add to not before (nbf) claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles |
| `jwt_oidc_roles.verbose_oidc_logging` | false | | Log received OIDC tokens and claims when debug-level logging is active. Not recommended in production since sensitive information may be present in OIDC responses |
| `jwt_oidc_roles.token_ttl` | false | | The incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time |
| `jwt_oidc_roles.token_max_ttl` | false | | The maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time |
| `jwt_oidc_roles.token_period` | false | | If set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value. At each renewal, the token's TTL will be set to the value of this field. Specified in seconds |
| `jwt_oidc_roles.token_policies` | false | | List of policies to encode onto generated tokens. Depending on the auth method, this list may be supplemented by user/group/other values |
| `jwt_oidc_roles.token_bound_cidrs` | false | | List of CIDR blocks; if set, specifies blocks of IP addresses which can authenticate successfully, and ties the resulting token to these blocks as well |
| `jwt_oidc_roles.token_explicit_max_ttl` | false | | If set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token_ttl and token_max_ttl would otherwise allow a renewal |
| `jwt_oidc_roles.token_no_default_policy` | false | | If set, the default policy will not be set on generated tokens; otherwise it will be added to the policies set in token_policies |
| `jwt_oidc_roles.token_num_uses` | false | | The period, if any, in number of seconds to set on the token |
| `jwt_oidc_roles.token_type` | false | | The type of token that should be generated. Can be service, batch, or default to use the mount's tuned default (which unless changed will be service tokens). For token store roles, there are two additional possibilities: default-service and default-batch which specify the type to return unless the client requests a different type at generation time |
| `identity_groups` | true | | List of identity groups |
| `identity_groups.group_id` | true | | Identity group name |
| `identity_groups.type` | false | internal | Type of the group, internal or external |
| `identity_groups.policies` | false | | A list of policies to apply to the group |
| `identity_groups.mount_type` | true | | Vault auth backend type |
| `identity_groups.mount_path` | true | | Vault auth backend path |
| `identity_groups.metadata` | false | | A map of additional metadata to associate with the group |

**Note:** Value for `auth_backends.type` variable must not be equal to "kubernetes", "jwt", "oidc".

**Note:** Only one of variable (`jwt_oidc_auth_backend.jwks_url`, `jwt_oidc_auth_backend.oidc_discovery_url`, `jwt_oidc_auth_backend.jwt_validation_pubkeys`) must be set for one backend.

**Note:** Cert auth backend must be enabled in `auth_backends` with the `path`.

**Note:** To use this auth method, "tls_disable" must be false in the Vault configuration. This is because the certificates are sent through TLS communication itself.

**Note:** If the auth backend was not created at the first start, you must manually delete it. The problem is described on the [forum](https://discuss.hashicorp.com/t/terraform-provider-for-vault-is-behaving-like-its-not-idempotent/13945).

#### Example

Usage example located in this [directory](example).

## Roadmap


## Feedback

For support and feedback please contact me:
- telegram: [@aarchimaev](https://t.me/aarchimaev)
- e-mail: a.archimaev@nixys.ru

## License

nxs-vault-app-init is released under the [Apache License 2.0](LICENSE).
