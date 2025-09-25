resource "helm_release" "app_data_postgresql__n8n" {
  name       = "homelab-app-data-postgresql--n8n"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-n8n"
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-postgresql--n8n
      path: /Users/Saurav_Sahu/.homelab-data/drives/drive-2tb-1/app-data/postgresql--n8n
      accessModes:
        - ReadWriteMany
      nodeAffinity:
        required:
          nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
              - colima
    pvc:
      enabled: true
      name: pvc-homelab-app-data-postgresql--n8n
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}

resource "helm_release" "app_data_n8n" {
  name       = "homelab-app-data-n8n"
  chart      = "./lib/helm-chart-openebs-persistence"
  namespace  = "homelab-n8n"
  create_namespace = true
  wait = false

  values = [
    <<EOF
    storage: 5Gi
    storageClassName: openebs-hostpath
    pv:
      enabled: true
      name: pv-homelab-app-data-n8n
      path: /Users/Saurav_Sahu/.homelab-data/drives/drive-2tb-1/app-data/n8n
      accessModes:
        - ReadWriteMany
      nodeAffinity:
        required:
          nodeSelectorTerms:
          - matchExpressions:
            - key: kubernetes.io/hostname
              operator: In
              values:
              - colima
    pvc:
      enabled: true
      name: pvc-homelab-app-data-n8n
    EOF
  ]

   lifecycle {
     prevent_destroy = true
   }
}
