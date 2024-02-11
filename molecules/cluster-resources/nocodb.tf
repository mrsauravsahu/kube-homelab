resource "helm_release" "app_data_nocodb" {
  name       = "homelab-app-data-nocodb"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 2Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-nocodb
      path: /homelab/drives/drive-2tb-1/app-data/nocodb
      accessModes:
        - ReadWriteMany
      nodeAffinity:
        required:
          nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
              - pi
    pvc:
      enabled: true
      name: pvc-homelab-app-data-nocodb
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}

resource "helm_release" "nocodb" {
  name       = "nocodb"
  chart      = "./apps/nocodb"
  namespace  = "homelab"
  values = [file("./config/externals/nocodb/values.yaml")]
  depends_on = [helm_release.pv_files]
}

resource "helm_release" "nocodb_ingress" {
  name       = "nocodb-ingress"
  chart      = "./lib/helm-chart-homelab-ingress"
  namespace  = "homelab"
  values = ["${templatefile("./config/externals/nocodb/ingress.values.tftpl", { hosts = var.cluster.hosts })}"]
  depends_on = [helm_release.nocodb]
}
