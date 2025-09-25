resource "helm_release" "app_data_ollama" {
  name       = "homelab-app-data-ollama"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "ollama"
  wait = false

  values = [
    <<EOF
    storage: 40Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-ollama
      path: /homelab/drives/drive-2tb-1/app-data/ollama
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
      enabled: true
      name: pvc-homelab-app-data-ollama
    EOF
  ]

  # lifecycle {
  #   prevent_destroy = true
  # }
}
