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
  })
  default = {
    name = "default"
    config_path = "/etc/rancher/k3s/k3s.yaml"
  }
}
