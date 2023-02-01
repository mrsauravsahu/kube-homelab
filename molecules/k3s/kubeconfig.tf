data "remote_file" "kubeconfig" {
  for_each = local.servers
  conn {
    host        = each.value.host
    user        = each.value.user
    private_key = file(each.value.private_key)
  }

  path        = "/etc/rancher/k3s/k3s.yaml"
  depends_on  = [
    ssh_resource.install_k3s
  ]
}
