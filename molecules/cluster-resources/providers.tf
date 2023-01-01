terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
      version = "2.6.0"
    }

    k8s = {
      source = "hashicorp/kubernetes"
      version = "2.12.0"
    }
  }

  backend "http" {
    address        = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-cluster-resources.json"
    lock_address   = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-cluster-resources.json"
    unlock_address = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-cluster-resources.json"
  }
}

provider "helm" {
  kubernetes {
    host = var.cluster.host
    config_path = var.cluster.config_path
  }
}

provider "k8s" {
  config_path = var.cluster.config_path
  config_context = var.cluster.name
}

