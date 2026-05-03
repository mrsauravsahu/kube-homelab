resource "random_password" "agent_token" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "ssh_resource" "install_k3s_server" {
  for_each = local.servers
  host     = each.value.host
  user     = each.value.user
  commands = [
    "curl -sfL ${local.k3s.download_url} | INSTALL_K3S_VERSION='${local.k3s.version}' K3S_AGENT_TOKEN=${random_password.agent_token.result} sh -s - server --docker --write-kubeconfig-mode 644 --disable=traefik"
    # TODO: For HA k3s cluster setup
    # "curl -sfL ${local.k3s.download_url} | INSTALL_K3S_VERSION='${local.k3s.version}' sh -s - server --cluster-init --docker --write-kubeconfig-mode 644 --disable=traefik"
  ]
  private_key = file(each.value.private_key)
  timeout = "10m"
}

# Note: Removed waiting for k3s server to be ready

resource "ssh_resource" "uninstall_k3s_server" {
  for_each    = { for server in var.servers : server.host => server }
  host        = each.value.host
  when        = "destroy"
  user        = each.value.user
  commands    = ["bash -c 'k3s-killall.sh; k3s-uninstall.sh;'"]
  private_key = file(each.value.private_key)
}
