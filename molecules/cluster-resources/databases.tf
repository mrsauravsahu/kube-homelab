resource "helm_release" "cnpg_operator" {
  count = length(var.databases) > 0 ? 1 : 0

  repository = "https://cloudnative-pg.github.io/charts"
  name       = "cloudnative-pg"
  chart      = "cloudnative-pg"
  namespace  = "cnpg-system"
  create_namespace = true
  
  values = ["${file("./config/cnpg-operator-values.yaml")}"]

  timeout = 600
}

resource "helm_release" "cnpg_clusters" {
  for_each = { for db in var.databases : db.name => db if db.type == "postgresql" }
  repository = "https://cloudnative-pg.github.io/charts"
  name       = each.value.name
  chart      = "cluster"
  namespace  = each.value.namespace != null ? each.value.namespace : each.value.name
  create_namespace = true
  timeout = 600
}
