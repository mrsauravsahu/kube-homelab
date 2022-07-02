resource "kubernetes_namespace" "homelab_ns" {
  metadata {
    annotations = {
      name = var.base.name
    }

    labels = {
      tier = "base"
    }

    name = var.base.name
  }
}

output "base" {
  description = "Base tier of the homelab"
  value = {
    ns = var.base.name
  }
}
