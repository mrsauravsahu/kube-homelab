variable "keycloak" {
  type = object({
    url = string
  })
}

variable "app" {
  type = object({
    name = string
  })
}
