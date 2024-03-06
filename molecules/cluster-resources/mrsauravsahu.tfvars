cluster = {
  name = "default"
  config_path = "../../config/<todo-add-domain>.kubeconfig"
  host = "https://<todo-add-domain>:6443"
  hosts = [
    "<todo-add-domain>",
  ]
}

namespaces = [
  { name = "argocd" }
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

externals = [
    {
      name = "ingress-nginx"
      repo = "https://kubernetes.github.io/ingress-nginx"
      version = "4.4.0"
    },
    {
     name = "hajimari"
     repo = "https://hajimari.io"
     version = "1.2.0"
     namespace = "homelab"
    },
    {
     name = "postgresql"
     repo = "https://charts.bitnami.com/bitnami"
     version = "13.1.0"
     namespace = "homelab"
    },
    {
     name = "rabbitmq"
     repo = "https://charts.bitnami.com/bitnami"
     version = "12.6.1"
     namespace = "homelab"
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
      name = "keycloak",
      repo = "https://codecentric.github.io/helm-charts",
      version = "20.0.3",
      namespace = "homelab"
    },
    #{
    # name = "prometheus",
    # repo = "https://prometheus-community.github.io/helm-charts",
    # version = "19.3.1",
    # namespace = "homelab"
    #},
   # {
    #  name = "grafana",
     # repo = "https://grafana.github.io/helm-charts",
      #version = "0.2.3",
     # namespace = "homelab"
    #},
    # {
    #   name = "loki",
    #   repo = "https://grafana.github.io/loki/charts",
    #   version = "2.1.1",
    #   namespace = "homelab"
    # },
    # https://grafana.com/blog/2022/06/23/how-to-send-logs-to-grafana-loki-with-the-opentelemetry-collector-using-fluent-forward-and-filelog-receivers
    # {
    #   name = "opentelemetry-collector",
    #   repo = "https://open-telemetry.github.io/opentelemetry-helm-charts"
    #   version = "v0.72.0",
    #   namespace = "payobills-dev"
    # },
   #{
   #   name = "opentelemetry-collector",
   #   repo = "https://open-telemetry.github.io/opentelemetry-helm-charts"
   #   version = "v0.72.0",
   #   namespace = "homelab"
   # },
  #{
  #    name = "kafka",
  #    repo = "https://charts.bitnami.com/bitnami",
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
    repo = "https://charts.bitnami.com/bitnami",
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
    namespace = "argocd"
  }
  # {
  #   name = "owncloud",
  #   repo = "https://owncloud-docker.github.io/helm-charts",
  #   version = "0.6.0",
  #   namespace = "homelab"
  # }
]
