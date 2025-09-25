resource "helm_release" "app_data_immich__externals" {
  name       = "homelab-app-data-immich-externals"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-immich"
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-immich-externals
      path: /homelab/drives/drive-2tb-1/user-files/mrsauravsahu/photos
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
      name: pvc-homelab-app-data-immich-externals
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
