resource "ssh_resource" "install_k3s" {
  for_each   = {for server in var.servers : server.host => server}
  host            = each.value.host
  user = each.value.user
  host_user = var.host.user
  commands            = [ <<EOF
  if [ "$(sudo systemctl status k3s.service > /dev/null; echo $?)" -ne "0" ]; then
    curl -sfL ${local.k3s.download_url} | INSTALL_K3S_VERSION='${local.k3s.version}' sh -s - server --cluster-init --docker --write-kubeconfig-mode 644 --disable=traefik
  else
    echo k3s already installed, skipping.
  fi
  EOF
  ]
  private_key        = file(var.host.private_key)
}

# TODO: replace with some form of wait until k3s is ready
resource "time_sleep" "wait_k3s_to_get_ready" {
  depends_on = [ssh_resource.install_k3s]
  create_duration = "30s"
}

resource "ssh_resource" "uninstall_k3s" {
  for_each   = {for server in var.servers : server.host => server}
  host            = each.value.host
  when = "destroy"
  user = each.value.user
  host_user = var.host.user
  commands            = [ <<EOF
  if [ $(sudo systemctl status k3s.service > /dev/null; echo $?) = "0" ]; then
    k3s-killall.sh && k3s-uninstall.sh
  else
    echo k3s not installed, skipping.
  fi
  EOF
  ]
  private_key        = file(var.host.private_key)
}
