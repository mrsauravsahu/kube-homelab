locals {
  namespaces_to_create = {
    for environment in var.per_environment_configuration:
    environment.name => environment.name == "production" ? var.base.name : format("%s-%s", var.base.name, environment.name)
  }
  extra_namespaces = {
    for ns in var.namespaces: ns.name => ns.name
  }
}

resource "kubernetes_namespace" "homelab" {
  for_each = merge(local.extra_namespaces, local.namespaces_to_create)
  metadata {
    annotations = {
      name = each.value
    }

    labels = {
      tier = "base"
    }

    name = each.value
  }

  provider = k8s
}

moved {
  from = kubernetes_namespace.homelab_ns
  to = kubernetes_namespace.homelab
}

moved {
  from = kubernetes_namespace.homelab
  to = kubernetes_namespace.homelab["production"]
}
