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
  description = "Details about external apps to install"
  type = list(object({
    name = string
    repo = string
    version = string
    namespace = optional(string)
  }))
  default = []
}
