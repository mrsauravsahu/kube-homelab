resource "kubernetes_namespace" "external_namespaces" {
  count = length(var.externals)
  metadata {
    annotations = {
      name = var.externals[count.index].name
    }

    labels = {
      tier = "externals"
    }

    name = var.externals[count.index].name
  }
}

resource "helm_release" "external_helm_releases" {
  count     = length(var.externals)
  repository = var.externals[count.index].repo
  name       = var.externals[count.index].name
  chart      = var.externals[count.index].name
  namespace  = var.externals[count.index].name

  atomic     = true
  depends_on = [
    kubernetes_namespace.external_namespaces
  ]
}
