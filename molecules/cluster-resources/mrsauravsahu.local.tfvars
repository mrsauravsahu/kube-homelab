cluster = {
  name = "default"
  config_path = "../../config/tab.kubeconfig"
  host = "https://localhost:6443"
  hosts = [
    "mrsauravsahu.in"
  ]
}

namespaces = [
  { name = "argocd" },
  { name = "cert-manager" }
]

per_environment_configuration = [
  {
    name = "sbx"
    applications = [
      "mongodb"
    ]
  },
  {
    name = "production"
    applications = []
  }
]

ingresses = [
  # {
  #   name = "payobills"
  #   namespace = "payobills"
  # },
  # {
  #   name = "payobills-graphql"
  #   namespace = "payobills"
  # },
  # {
  #   name = "payobills-bills-graphql"
  #   namespace = "payobills"
  # },
  # {
  #   name = "payobills-payments-graphql"
  #   namespace = "payobills"
  # }
]

databases = [
  # {
  #   type = "postgresql",
  #   namespace = "homelab",
  #   name = "keycloak-db"  
  # }
]

externals = [
  {
    name = "ingress-nginx"
    repo = "https://kubernetes.github.io/ingress-nginx"
    version = "4.10.0"
  },
  {
    name = "hajimari"
    repo = "https://hajimari.io"
    version = "1.2.0"
    namespace = "homelab"
  },
  {
    name = "postgresql"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "13.1.0"
    namespace = "homelab"
  },
  # {
  #   name = "redis"
  #   repo = "oci://registry-1.docker.io/bitnamicharts"
  #   version = "20.2.1"
  #   namespace = "homelab"
  # },
  {
    name = "postgresql--keycloak"
    chart_name = "postgresql"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "13.1.0"
    namespace = "homelab-keycloak"
  },
  {
    name = "postgresql--n8n"
    chart_name = "postgresql"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "13.1.0"
    namespace = "homelab-n8n"
  },
  {
    name = "n8n"
    chart_name = "n8n"
    repo = "oci://8gears.container-registry.com/library"
    version = "1.0.0"
    namespace = "homelab-n8n"
  },
  {
    name = "gpu-operator",
    repo = "https://helm.ngc.nvidia.com/nvidia",
    version = "v25.3.1",
    namespace = "gpu-operator"
  },
  {
    name = "postgresql--idp"
    chart_name = "postgresql"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "13.1.0"
    namespace = "homelab"
  },
  {
    name = "postgresql--immich"
    chart_name = "postgresql"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "13.1.0"
    namespace = "homelab-immich"
  },
  {
    name = "rabbitmq"
    repo = "oci://registry-1.docker.io/bitnamicharts"
    version = "12.6.1"
    namespace = "homelab"
  },
  {
    name = "cert-manager"
    repo = "https://charts.jetstack.io"
    version = "1.14.5"
    namespace = "cert-manager"
  },

  // TODO: nextcloud fails due to slow startup, need to figure this out
  #  {
  #    name = "nextcloud"
  #    repo = "https://nextcloud.github.io/helm"
  #    version = "3.3.6"
  #    namespace = "homelab"
  #  },
  # {
  #   name = "coredns",
  #   repo = "https://coredns.github.io/helm",
  #   version = "1.19.7",
  #   namespace = "homelab"
  # }
  {
    name = "pihole",
    repo = "https://mojo2600.github.io/pihole-kubernetes/",
    version = "2.11.0",
    namespace = "homelab"
  },
  {
    name = "drawio",
    repo = "oci://tccr.io/truecharts",
    version = "drawio-13.3.2",
    namespace = "homelab"
  },
  {
    name = "keycloak",
    repo = "oci://registry-1.docker.io/bitnamicharts",
    version = "20.0.3",
    namespace = "homelab-keycloak"
  },
  # {
  #   name = "keycloak",
  #   repo = "oci://registry-1.docker.io/bitnamicharts",
  #   version = "21.4.4",
  #   namespace = "homelab"
  # },
  # {
  #   name = "keycloak",
  #   repo = "https://codecentric.github.io/helm-charts",
  #   version = "20.0.3",
  #   namespace = "homelab"
  # },
  {
    name = "prometheus",
    repo = "https://prometheus-community.github.io/helm-charts",
    version = "25.19.1",
    namespace = "homelab"
  },
  {
    name = "grafana",
    repo = "https://grafana.github.io/helm-charts",
    version = "8.0.2",
    namespace = "homelab"
  },
  # {
  #   name = "grafana",
  #   repo = "https://grafana.github.io/helm-charts",
  #   version = "0.2.3",
  #   namespace = "homelab"
  # },
  {
    name = "loki-stack",
    repo = "https://grafana.github.io/helm-charts",
    version = "2.8.0",
    namespace = "homelab"
  },
  {
    name = "immich",
    repo = "oci://ghcr.io/immich-app/immich-charts/immich",
    version = "0.9.2",
    namespace = "homelab-immich"
  },
  
  # https://grafana.com/blog/2022/06/23/how-to-send-logs-to-grafana-loki-with-the-opentelemetry-collector-using-fluent-forward-and-filelog-receivers
  {
    name = "opentelemetry-collector",
    repo = "https://open-telemetry.github.io/opentelemetry-helm-charts"
    version = "v0.72.0",
    namespace = "payobills"
  },
  #  {
  #    name = "opentelemetry-collector",
  #    repo = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  #    version = "v0.72.0",
  #    namespace = "homelab"
  #  },
  #{
  #    name = "kafka",
  #    repo = "oci://registry-1.docker.io/bitnamicharts",
  #    version = "21.3.0"
  #},
  # {
  #   name = "zeebe-full-helm",
  #   repo = "https://helm.camunda.io"
  #   version = "1.3.5",
  #   namespace = "homelab"
  # },
  # {
  #   name = "dapr",
  #   repo = "https://dapr.github.io/helm-charts/",
  #   version = "1.10.5",
  #   namespace = "dapr-system"
  # },
  {
    name = "openebs",
    repo = "https://openebs.github.io/charts",
    version = "2.11.0",
    namespace = "homelab"
  },
  {
    name = "mongodb",
    repo = "oci://registry-1.docker.io/bitnamicharts",
    version = "14.0.5",
    namespace = "homelab"
  },
  # {
  #   name = "couchdb",
  #   repo = "https://apache.github.io/couchdb-helm",
  #   version = "4.4.4",
  #   namespace = "homelab"
  # },
  {
    name = "minio",
    repo = "https://charts.min.io/",
    version = "5.0.14",
    namespace = "homelab"
  },
  {
    name = "argo-cd",
    repo = "https://argoproj.github.io/argo-helm",
    version = "6.0.6",
    namespace = "argo-cd"
  },
  # {
  #   name = "vault",
  #   repo = "https://helm.releases.hashicorp.com",
  #   version = "0.27.0",
  #   namespace = "homelab"
  # },
  # {
  #   name = "krakend",
  #   repo = "https://helm.equinixmetal.com",
  #   version = "0.1.16"
  # },
  # {
  #   name = "ingress",
  #   repo = "https://charts.konghq.com",
  #   version = "0.10.2",
  #   namespace = "homelab"
  # },
  # {
  #   name = "kong",
  #   repo = "https://charts.konghq.com",
  #   version = "2.35.1",
  #   namespace = "homelab"
  # }
]
