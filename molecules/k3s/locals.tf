locals {
  k3s = coalesce({
    download_url = "https://get.k3s.io",
    version = "v1.25.5+k3s1"
  }, var.k3s)

  servers = {for server in var.servers : server.host => server}
}
