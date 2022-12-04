resource "helm_release" "external_apps" {
  count     = length(var.externals)
  repository = var.externals[count.index].repo
  name       = var.externals[count.index].name
  chart      = var.externals[count.index].name
  namespace  = var.externals[count.index].name
  create_namespace = true
  values = fileexists("${path.module}/../config/externals/${var.externals[count.index].name}/values.yaml") == true ? ["${file("${path.module}/../config/externals/${var.externals[count.index].name}/values.yaml")}"] : []

  atomic     = true
}

resource "helm_release" "external_ingresses" {
  for_each     = {for app in helm_release.external_apps.* : app.name => app if fileexists("${path.module}/../config/externals/${app.name}/ingress.values.yaml")}
  name       = "${each.value.name}-ingress"
  chart      = "${path.module}/../lib/helm-chart-homelab-ingress"
  namespace  = each.value.name

  values = ["${file("${path.module}/../config/externals/${each.value.name}/ingress.values.yaml")}"]

  atomic     = true
  depends_on = [
    helm_release.external_apps
  ]
}
