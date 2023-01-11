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
}

variable "externals" {
  description = "Details about external items to install"
  type = list(object({
    name = string
    repo = string
    version = string
    namespace = optional(string)
  }))
  // Feel free to move the applications arround, the order in the array does not matter
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
    },
    // TODO: nextcloud fails due to slow startup, need to figure this out
    # {
    #   name = "nextcloud"
    #   repo = "https://nextcloud.github.io/helm"
    #   version = "3.3.6"
    #   namespace = "homelab"
    # },
    # {
    #   name = "coredns",
    #   repo = "https://coredns.github.io/helm",
    #   version = "1.19.7",
    #   namespace = "homelab"
    # }
    {
      name = "pihole",
      repo = "https://mojo2600.github.io/pihole-kubernetes/",
      version = "2.11.0",
      namespace = "homelab"
    },
    {
      name = "keycloak",
      repo = "https://codecentric.github.io/helm-charts",
      version = "18.4.0",
      namespace = "homelab"
    },
    {
      name = "prometheus",
      repo = "https://prometheus-community.github.io/helm-charts",
      version = "19.3.1",
      namespace = "homelab"
    },
    {
      name = "grafana",
      repo = "https://grafana.github.io/helm-charts",
      version = "6.49.0",
      namespace = "homelab"
    }
  ]
}
