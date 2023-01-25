output "base" {
  description = "Base namespace of the homelab"
  value = {
    ns = var.base.name
  }
}

output "apps" {
  description = "Installed applications list"
  value = [for app in helm_release.external_apps : app.name ]
}

output "ingresses" {
  description = "Applications exposed with nginx-ingress"
  value = [for ingress in helm_release.external_ingresses : ingress.name ]
}
