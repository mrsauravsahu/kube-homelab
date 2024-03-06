resource "helm_release" "app_data_rabbitmq" {
  name       = "homelab-app-data-rabbitmq"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab"
  wait = false

  values = [
    <<EOF
    storage: 8Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-rabbitmq
      path: /homelab/drives/drive-2tb-1/app-data/rabbitmq
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
      name: pvc-homelab-app-data-rabbitmq
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
