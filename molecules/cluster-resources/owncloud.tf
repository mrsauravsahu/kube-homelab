resource "helm_release" "pv_files" {
  name       = "homelab-pv-files"
  chart      = "./lib/helm-chart-openebs-pv"
  namespace  = "homelab"

  values = [
    <<EOF
    pv:
      enabled: true
      name: homelab-pv-files
      storageClassName: openebs-hostpath
      storage: 1.8Ti
      path: /homelab/drives/drive-2tb-1/files
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

resource "helm_release" "owncloud" {
  name       = "owncloud"
  chart      = "./apps/owncloud"
  namespace  = "homelab"
  values = [file("./config/externals/owncloud/values.yaml")]
  depends_on = [helm_release.pv_files]
}

resource "helm_release" "owncloud_ingress" {
  name       = "owncloud-ingress"
  chart      = "./lib/helm-chart-homelab-ingress"
  namespace  = "homelab"
  values = ["${templatefile("./config/externals/owncloud/ingress.values.tftpl", { hosts = var.cluster.hosts })}"]
  depends_on = [helm_release.owncloud]
}
