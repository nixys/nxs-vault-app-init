# vault-init

vault-init is an open source module for terraform. This module create policies, secrets engines, auth backends (certs, jwt, oidc, kubernetes, etc), jwt/oidc roles and identity groups. Also module generate tls certs and jwt keys in specific directory.

# Variables

* `output_files_path`: the path to directorie where save generated tls certs and jwt keys. Default: "./files".
* `vault_addr`: vault addres.
* `vault_admin_token`: vault admin token.
* `vault_skip_tls_verify`(optional): set this to true to disable verification of the Vault server's TLS certificate. Default: "false".
* `policies`: list of policies to create.
* * `name`: name of the policy.
* * `paths`: list of paths for secrets engines.
* * `capabilities`: list of capabilities for policy.
* `secrets_engines`: list of secrets engines.
* * `path`: secret engine path.
* * `type`: secret engine type.
* * `options`(optional): secret engine options.
* `auth_backends`: list of auth backends.
* * `type`: auth backend type.
* * `path`(optional): auth backend path. Default value equal to type.
* * `tune`(optional): auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune).

**Note:** Value for `type` variable must not be equal to "kubernetes", "jwt", "oidc".

* `jwt_oidc_auth_backend`: list of jwt/oidc auth backends.
* * `path`: auth backend path.
* * `type`(optional): auth backend type. Default: "jwt".
* * `oidc_discovery_url`(optional): the OIDC Discovery URL, without any .well-known component (base path). Cannot be used in combination with `jwt_validation_pubkeys`.
* * `oidc_discovery_ca_pem`(optional): the CA certificate or chain of certificates, in PEM format, to use to validate connections to the OIDC Discovery URL. If not set, system certificates are used.
* * `oidc_client_id`(optional): client ID used for OIDC backends.
* * `oidc_client_secret`(optional): client Secret used for OIDC backends.
* * `oidc_response_mode`(optional): the response mode to be used in the OAuth2 request. Allowed values are "query" and "form_post". Defaults to "query". If using Vault namespaces, and `oidc_response_mode` is "form_post", then `namespace_in_state` should be set to "false".
* * `oidc_response_types`(optional): list of response types to request. Allowed values are "code" and "id_token". Defaults to ["code"]. Note: "id_token" may only be used if `oidc_response_mode` is set to form_post.
* * `jwks_url`(optional): JWKS URL to use to authenticate signatures. Cannot be used with `oidc_discovery_url` or `jwt_validation_pubkeys`.
* * `jwks_ca_pem`(optional): the CA certificate or chain of certificates, in PEM format, to use to validate connections to the JWKS URL. If not set, system certificates are used.
* * `jwt_validation_pubkeys`(optional): a list of PEM-encoded public keys to use to authenticate signatures locally. Cannot be used in combination with `oidc_discovery_url`.
* * `bound_issuer`(optional): the value against which to match the iss claim in a JWT.
* * `jwt_supported_algs`(optional): a list of supported signing algorithms. Vault 1.1.0 defaults to [RS256] but future or past versions of Vault may differ.
* * `default_role`(optional): the default role to use if none is provided during login.
* * `provider_config`(optional): provider specific handling configuration. All values may be strings, and the provider will convert to the appropriate type when configuring Vault.
* * `local`(optional): specifies if the auth method is local only.
* * `namespace_in_state`(optional): pass namespace in the OIDC state parameter instead of as a separate query parameter. With this setting, the allowed redirect URL(s) in Vault and on the provider side should not contain a namespace query parameter. This means only one redirect URL entry needs to be maintained on the OIDC provider side for all vault namespaces that will be authenticating against it. Defaults to true for new configs.
* * `tune`(optional): auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune).

**Note:** Only one of variable (`jwks_url`, `oidc_discovery_url`, `jwt_validation_pubkeys`) must be set for one backend.

* `certs_auth_backend`: list of certs auth backends.
* * `name`: cert name.
* * `policies`: list of policies.
* * `path`(optional): certs auth backend path. Default: "cert".
* * `tls_self_signed_cert`: cert info.
* * * `common_name`(optional): cert common name.
* * * `organization`(optional): cert organization.
* * * `allowed_uses`: list of [keywords](https://registry.terraform.io/providers/hashicorp/tls/3.2.1/docs/resources/self_signed_cert#allowed_uses) each describing a use that is permitted for the issued certificate.
* * * `convert_to_pkcs12`(optional): create or not pkcs12 cert. Default: "false".

**Note:** Cert auth backend must be enabled in `auth_backends` with the `path`.

**Note:** To use this auth method, "tls_disable" must be false in the Vault configuration. This is because the certificates are sent through TLS communication itself.

* `kubernetes_auth_backends`: list of kubernetes auth backends.
* * `path`(optional): auth backend path. Default: "kubernetes".
* * `kubernetes_host`: host must be a host string, a host:port pair, or a URL to the base of the Kubernetes API server.
* * `kubernetes_ca_cert`(optional): PEM encoded CA cert for use by the TLS client used to talk with the Kubernetes API.
* * `token_reviewer_jwt`(optional): a service account JWT used to access the TokenReview API to validate other JWTs during login. If not set the JWT used for login will be used to access the API.
* * `issuer`(optional): JWT issuer.
* * `roles`(optional): list of roles.
* * * `role_name`: role name.
* * * `bound_service_account_names`: list of service account names able to access this role. If set to ["\*"] all names are allowed, both this and bound_service_account_namespaces can not be "\*".
* * * `bound_service_account_namespaces`: list of namespaces allowed to access this role. If set to ["\*"] all namespaces are allowed, both this and bound_service_account_names can not be set to "\*".
* * * `token_policies`(optional): list of policies to encode onto generated tokens.
* * `tune`(optional): auth backend [tune](https://registry.terraform.io/providers/hashicorp/vault/3.2.1/docs/resources/auth_backend#tune).
* `vault_tokens`: list of vault tokens.
* * `display_name`: token display name.
* * `policies`: token policies.
* * `role_name`(optional): the token role name.
* * `renewable`(optional): flag to allow to renew this token.
* * `ttl`(optional): the TTL period of this token.
* * `explicit_max_ttl`(optional): the explicit max TTL of this token.
* * `period`(optional): the period of this token.
* * `renew_min_lease`(optional): the minimal lease to renew this token.
* * `renew_increment`(optional): the renew increment.
* `vault_token_roles`: list of vault token auth backend roles.
* * `role_name`: the name of the role.
* * `allowed_policies`(optional): list of allowed policies for given role.
* * `disallowed_policies`(optional): list of disallowed policies for given role.
* * `orphan`(optional): if true, tokens created against this policy will be orphan tokens.
* * `renewable`(optional): whether to disable the ability of the token to be renewed past its initial TTL.
* * `path_suffix`(optional): tokens created against this role will have the given suffix as part of their path in addition to the role name.
* * `token_period`(optional): if set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value. At each renewal, the token's TTL will be set to the value of this field. Specified in seconds.
* * `token_ttl`(optional): the incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time.
* * `token_max_ttl`(optional): the maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time.
* * `token_explicit_max_ttl`(optional): if set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if `token_ttl` and `token_max_ttl` would otherwise allow a renewal.
* `jwt_oidc_roles`: list of jwt/oidc roles.
* * `name`: role name.
* * `path`: auth backend path.
* * `type`(optional): role type.
* * `user_claim`: the claim to use to uniquely identify the user; this will be used as the name for the Identity entity alias created due to a successful login.
* * `bound_claims`(optional): if set, a map of claims to values to match against. A claim's value must be a string, which may contain one value or multiple comma-separated values, e.g. "red" or "red,green,blue".
* * `bound_audiences`(optional): list of aud claims to match against. Any match is sufficient.
* * `bound_subject`(optional): if set, requires that the sub claim matches this value.
* * `bound_claims_type`(optional): how to interpret values in the claims/values map (bound_claims): can be either string (exact match) or glob (wildcard match). Requires Vault 1.4.0 or above.
* * `claim_mappings`(optional): if set, a map of claims (keys) to be copied to specified metadata fields (values).
* * `oidc_scopes`(optional): if set, a list of OIDC scopes to be used with an OIDC role. The standard scope "openid" is automatically included and need not be specified.
* * `groups_claim`(optional): the claim to use to uniquely identify the set of groups to which the user belongs; this will be used as the names for the Identity group aliases created due to a successful login. The claim value must be a list of strings.
* * `allowed_redirect_uris`(optional): the list of allowed values for redirect_uri during OIDC logins. Required for OIDC roles.
* * `clock_skew_leeway`(optional): the amount of leeway to add to all claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles.
* * `expiration_leeway`(optional): the amount of leeway to add to expiration (exp) claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles.
* * `not_before_leeway`(optional): the amount of leeway to add to not before (nbf) claims to account for clock skew, in seconds. Defaults to 60 seconds if set to 0 and can be disabled if set to -1. Only applicable with "jwt" roles.
* * `verbose_oidc_logging`(optional): log received OIDC tokens and claims when debug-level logging is active. Not recommended in production since sensitive information may be present in OIDC responses.
* * `token_ttl`(optional): the incremental lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time.
* * `token_max_ttl`(optional): the maximum lifetime for generated tokens in number of seconds. Its current value will be referenced at renewal time.
* * `token_period`(optional): if set, indicates that the token generated using this role should never expire. The token should be renewed within the duration specified by this value. At each renewal, the token's TTL will be set to the value of this field. Specified in seconds.
* * `token_policies`(optional): list of policies to encode onto generated tokens. Depending on the auth method, this list may be supplemented by user/group/other values.
* * `token_bound_cidrs`(optional): list of CIDR blocks; if set, specifies blocks of IP addresses which can authenticate successfully, and ties the resulting token to these blocks as well.
* * `token_explicit_max_ttl`(optional): if set, will encode an explicit max TTL onto the token in number of seconds. This is a hard cap even if token_ttl and token_max_ttl would otherwise allow a renewal.
* * `token_no_default_policy`(optional): if set, the default policy will not be set on generated tokens; otherwise it will be added to the policies set in token_policies.
* * `token_num_uses`(optional): the period, if any, in number of seconds to set on the token.
* * `token_type`(optional): the type of token that should be generated. Can be service, batch, or default to use the mount's tuned default (which unless changed will be service tokens). For token store roles, there are two additional possibilities: default-service and default-batch which specify the type to return unless the client requests a different type at generation time.

**Note:** If the auth backend was not created at the first start, you must manually delete it. The problem is described on the [forum](https://discuss.hashicorp.com/t/terraform-provider-for-vault-is-behaving-like-its-not-idempotent/13945).

* `identity_groups`: list of identity groups.
* * `group_id`: identity group name.
* * `type`(optional): type of the group, internal or external. Default: "internal".
* * `policies`(optional): a list of policies to apply to the group.
* * `mount_type`: vault auth backend type.
* * `mount_path`: vault auth backend path.
* * `metadata`(optional): a map of additional metadata to associate with the group.

Usage example located in this [directory](example).
