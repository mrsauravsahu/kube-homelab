data "remote_file" "kubeconfig" {
  for_each = local.servers
  conn {
    host        = each.value.host
    user        = each.value.user
    private_key = file(var.host.private_key)
  }

  path        = "/etc/rancher/k3s/k3s.yaml"
}
