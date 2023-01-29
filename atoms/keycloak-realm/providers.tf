terraform {
  required_version = ">=1.3.0"

  required_providers {
    keycloak = {
      source  = "mrparkers/keycloak"
      version = "3.6.0"
    }
  }

  backend "http" { }
}

provider "keycloak" {
  client_id                = "admin-cli"
  username                 = var.keycloak.admin.username
  password                 = var.keycloak.admin.password
  url                      = var.keycloak.url
  tls_insecure_skip_verify = true
}
