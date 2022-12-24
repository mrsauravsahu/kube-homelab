terraform {

  experiments = [module_variable_optional_attrs]

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
}

provider "helm" {
  kubernetes {
    config_path = var.cluster.config_path
  }
}

provider "k8s" {
  config_path = var.cluster.config_path
  config_context = var.cluster.name
}

