resource "helm_release" "app_data_postgresql" {
  name       = "homelab-app-data-postgresql"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 2Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-postgresql
      path: /homelab/drives/drive-2tb-1/app-data/postgresql
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
      name: pvc-homelab-app-data-postgresql
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
