resource "helm_release" "homelab_data_pv" {
  name       = "homelab-data-pv"
  chart      = "./lib/helm-chart-openebs-pv"
  namespace  = "homelab"

  values = [
    <<EOF
    pv:
      enabled: true
      name: homelab-data-pv
      storageClassName: openebs-hostpath
      storage: 1.8Ti
      path: /homelab/owncloud-test/media
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
    EOF
  ]

  lifecycle {
    prevent_destroy = true
  }
}