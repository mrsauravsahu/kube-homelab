resource "helm_release" "nocodb" {
  name       = "nocodb"
  chart      = "./apps/nocodb"
  namespace  = "homelab"
  values = [file("./config/externals/nocodb/values.yaml")]
  depends_on = [helm_release.pv_files]
}

resource "helm_release" "nocodb_ingress" {
  name       = "nocodb-ingress"
  chart      = "./lib/helm-chart-homelab-ingress"
  namespace  = "homelab"
  values = ["${templatefile("./config/externals/nocodb/ingress.values.tftpl", { hosts = var.cluster.hosts })}"]
  depends_on = [helm_release.nocodb]
}
