locals {
  k3s = coalesce({
    download_url = "https://get.k3s.io",
    version = "v1.26.0+k3s1"
  }, var.k3s)
}
