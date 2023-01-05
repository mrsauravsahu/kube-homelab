terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.24.0"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
    vagrant = {
      source = "bmatcuk/vagrant"
      version = "4.1.0"
    }
  }
}

provider "docker" { }
provider "tls" { }
provider "local" { }
provider "vagrant" { }
