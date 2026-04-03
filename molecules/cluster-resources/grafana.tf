resource "helm_release" "app_data_grafana" {
  name       = "homelab-app-data-grafana"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 8Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-grafana
      path: /homelab/drives/drive-2tb-1/app-data/grafana
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
      name: pvc-homelab-app-data-grafana
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}

