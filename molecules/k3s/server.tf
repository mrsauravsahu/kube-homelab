resource "ssh_resource" "install_k3s" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  commands = [
    "curl -sfL ${local.k3s.download_url} | INSTALL_K3S_VERSION='${local.k3s.version}' sh -s - server --docker --write-kubeconfig-mode 644 --disable=traefik"
    # TODO: For HA k3s cluster setup
    # "curl -sfL ${local.k3s.download_url} | INSTALL_K3S_VERSION='${local.k3s.version}' sh -s - server --cluster-init --docker --write-kubeconfig-mode 644 --disable=traefik"
  ]
  private_key = file(each.value.private_key)
  timeout = "10m"
}

# TODO: replace with some form of wait until k3s is ready
resource "time_sleep" "wait_k3s_to_get_ready" {
  depends_on      = [ssh_resource.install_k3s]
  create_duration = "30s"
}

resource "ssh_resource" "uninstall_k3s" {
  for_each    = { for server in var.servers : server.host => server }
  host        = each.value.host
  when        = "destroy"
  user        = each.value.user
  commands    = ["bash -c 'k3s-killall.sh; k3s-uninstall.sh;'"]
  private_key = file(each.value.private_key)
}
