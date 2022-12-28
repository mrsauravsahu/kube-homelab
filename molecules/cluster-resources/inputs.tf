variable "base" {
  description = "Basic details about the project"
  type = object({
    name = string
  })
  default = {
    name = "homelab"
  }
}

variable "cluster" {
  description = "Details about the cluster"
  type = object({
    name = string
    config_path = string
    host = string
    hosts = list(string)
  })
  default = {
    name = "default"
    config_path = "../../config/kubeconfig"
    host = "https://192.168.0.100:6443"
    hosts = [
      "pi",
      "pi.local"
    ]
  }
}

variable "externals" {
  description = "Details about external items to install"
  type = list(object({
    name = string
    repo = string
    version = string
    namespace = optional(string)
  }))
  default = [
    {
      name = "ingress-nginx"
      repo = "https://kubernetes.github.io/ingress-nginx"
      version = "4.4.0"
    },
    {
      name = "hajimari"
      repo = "https://hajimari.io"
      version = "1.2.0"
      namespace = "homelab"
    },
    {
      name = "postgresql"
      repo = "https://cetic.github.io/helm-charts"
      version = "0.2.3"
      namespace = "homelab"
    }
  ]
}
