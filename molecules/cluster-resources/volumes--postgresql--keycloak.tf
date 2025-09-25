resource "helm_release" "app_data_postgresql__keycloak" {
  name       = "homelab-app-data-postgresql--keycloak"
  chart      = "./lib/helm-chart-openebs-persistence"
  create_namespace = true
  namespace  = "homelab-keycloak"
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-postgresql--keycloak
      path: /homelab/drives/drive-2tb-1/app-data/postgresql--keycloak
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
      name: pvc-homelab-app-data-postgresql--keycloak
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
