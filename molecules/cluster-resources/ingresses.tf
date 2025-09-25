resource "helm_release" "ingresses" {
  for_each     = {for app in var.ingresses : app.name => app if fileexists("./config/ingresses/${app.name}.tftpl")}
  name       = "${each.value.name}-ingress"
  chart      = "./lib/helm-chart-homelab-ingress-tls"
  namespace  = each.value.namespace

  values = ["${templatefile("./config/ingresses/${each.value.name}.tftpl", { hosts = var.cluster.hosts })}"]

  # depends_on = [
  #   helm_release.external_apps
  # ]
}
