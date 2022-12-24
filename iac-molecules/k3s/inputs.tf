variable "host" {
  description = "machine on which terraform is running"
  type = object({
    user = string
    private_key = string
  })
}

variable "servers" {
  description = "machines which will run the control plane"
  type = list(object({
    host = string
    user = string
    private_key = string
  }))
  default = []
}

variable "k3s" {
  type = object({
    download_url = optional(string),
    version = optional(string),
  })
  default = {}
}