resource "helm_release" "app_data_mongodb" {
  name       = "homelab-app-data-mongodb"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 2Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-mongodb
      path: /homelab/drives/drive-2tb-1/app-data/mongodb
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
      name: pvc-homelab-app-data-mongodb
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
