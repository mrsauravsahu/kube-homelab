resource "helm_release" "bills_ingresses" {
  for_each     = {for app in helm_release.external_apps : app.name => app if fileexists("./config/externals/${app.name}/ingress.values.tftpl")}
  name       = "${each.value.name}-ingress"
  chart      = "./lib/helm-chart-homelab-ingress"
  namespace  = each.value.namespace

  values = ["${templatefile("./config/externals/${each.value.name}/ingress.values.tftpl", { hosts = var.cluster.hosts })}"]

  depends_on = [
    helm_release.external_apps
  ]
}
