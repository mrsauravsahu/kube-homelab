resource "helm_release" "app_data_postgresql__openwebui" {
  name       = "homelab-app-data-postgresql--openwebui"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-openwebui"
  wait = false

  values = [
    <<EOF
    storage: 2Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-postgresql--openwebui
      path: /homelab/drives/drive-2tb-1/app-data/postgresql--openwebui
      accessModes:
        - ReadWriteMany
      nodeAffinity:
        required:
          nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
              - msi-pc-linux
    pvc:
      enabled: false
      name: pvc-homelab-app-data-postgresql--openwebui
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
