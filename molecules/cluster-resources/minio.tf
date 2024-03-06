resource "helm_release" "app_data_minio" {
  name       = "homelab-app-data-minio"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 2Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-minio
      path: /homelab/drives/drive-2tb-1/app-data/minio
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
      name: pvc-homelab-app-data-minio
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
