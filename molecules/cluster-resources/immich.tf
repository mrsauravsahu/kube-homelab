resource "helm_release" "app_data_immich" {
  name       = "homelab-app-data-immich"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-immich"
  wait = false

  values = [
    <<EOF
    storage: 200Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-immich
      path: /homelab/drives/drive-2tb-1/app-data/immich/library
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
      name: pvc-homelab-app-data-immich
    EOF
  ]

#    lifecycle {
#      prevent_destroy = true
#    }
}

resource "helm_release" "app_data_immich__cache" {
  name       = "homelab-app-data-immich--cache"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-immich"
  wait = false

  values = [
    <<EOF
    storage: 10Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-immich--cache
      path: /homelab/drives/drive-2tb-1/app-data/immich/cache
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
      name: pvc-homelab-app-data-immich--cache
    EOF
  ]

#    lifecycle {
#      prevent_destroy = true
#    }
}
