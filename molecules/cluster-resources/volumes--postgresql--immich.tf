resource "helm_release" "app_data_postgresql__immich" {
  name       = "homelab-app-data-postgresql--immich"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-immich"
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-postgresql--immich
      path: /homelab/drives/drive-2tb-1/app-data/postgresql--immich
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
      name: pvc-homelab-app-data-postgresql--immich
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}

resource "helm_release" "postgresql__immich__extensions_vector" {
  name       = "postgresql--immich--extensions-vector"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-immich"
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-postgresql--immich--extensions-vector
      path: /homelab/drives/drive-2tb-1/mnt/vectors-pg16
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
      name: pvc-postgresql--immich--extensions-vector
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
