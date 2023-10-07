resource "helm_release" "owncloud" {
  name       = "owncloud"
  chart      = "./apps/owncloud"
  namespace  = "homelab"
  values = [file("./config/externals/owncloud/values.yaml")]
  depends_on = [helm_release.homelab_data_pv]
}

resource "helm_release" "owncloud_ingress" {
  name       = "owncloud-ingress"
  chart      = "./lib/helm-chart-homelab-ingress"
  namespace  = "homelab"
  values = ["${templatefile("./config/externals/owncloud/ingress.values.tftpl", { hosts = var.cluster.hosts })}"]
  depends_on = [helm_release.owncloud]
}
