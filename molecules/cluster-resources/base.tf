resource "kubernetes_namespace" "homelab" {
  metadata {
    annotations = {
      name = var.base.name
    }

    labels = {
      tier = "base"
    }

    name = var.base.name
  }

  provider = k8s
}

moved {
  from = kubernetes_namespace.homelab_ns
  to = kubernetes_namespace.homelab
}
