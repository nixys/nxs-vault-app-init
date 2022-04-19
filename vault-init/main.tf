terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.2.1"
    }
    pkcs12 = {
      source  = "chilicat/pkcs12"
      version = "0.0.7"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.1.2"
    }
  }
  required_version = ">= v1.0.0"
}

provider "vault" {
  address         = var.vault_addr
  token           = var.vault_admin_token
  skip_tls_verify = var.vault_skip_tls_verify
}

