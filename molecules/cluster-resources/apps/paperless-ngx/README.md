# Paperless-ngx

Self-hosted [Paperless-ngx](https://docs.paperless-ngx.com) at `paperless.mrsauravsahu.in`,
in namespace `homelab--paperless-ngx`. Deployed with `helm` directly (no terraform).

| Release | Chart | Values |
| --- | --- | --- |
| `homelab-app-data-postgresql--paperless-ngx` | `lib/helm-chart-openebs-persistence` | `config/externals/postgresql--paperless-ngx/pv.values.yaml` |
| `homelab-app-data-paperless-ngx` | `lib/helm-chart-openebs-persistence` | `config/externals/paperless-ngx/pv.values.yaml` |
| `postgresql--paperless-ngx` | `bitnami/postgresql` | `config/externals/postgresql--paperless-ngx/values.yaml` |
| `paperless-ngx` | `apps/paperless-ngx` | `config/externals/paperless-ngx/values.yaml` |
| `paperless-ngx-ingress` | `lib/helm-chart-homelab-ingress-tls` | `config/externals/paperless-ngx/ingress-tls.values.yaml` |

Run all commands from `molecules/cluster-resources`.

## 1. Create the host dirs (on node `pi`)

Same pattern as `postgresql--idp` / `postgresql--immich`: the PVs are `local` volumes,
so the dirs must exist before the pods start.

```bash
# Postgres data (bitnami runs as uid 1001)
sudo mkdir -p /homelab/drives/drive-2tb-1/app-data/postgresql--paperless-ngx
sudo chown -R 1001:1001 /homelab/drives/drive-2tb-1/app-data/postgresql--paperless-ngx

# Paperless data, media, consume, export (USERMAP_UID/GID = 1000)
sudo mkdir -p /homelab/drives/drive-2tb-1/app-data/paperless-ngx/{data,media,consume,export}
sudo chown -R 1000:1000 /homelab/drives/drive-2tb-1/app-data/paperless-ngx
```

## 2. Namespace, secrets, cert issuer

```bash
kubectl create namespace homelab--paperless-ngx

kubectl -n homelab--paperless-ngx create secret generic postgresql--paperless-ngx \
  --from-literal=postgres-password="$(openssl rand -base64 24)" \
  --from-literal=password="$(openssl rand -base64 24)"

kubectl -n homelab--paperless-ngx create secret generic paperless-ngx \
  --from-literal=secret-key="$(openssl rand -base64 48)" \
  --from-literal=admin-user=admin \
  --from-literal=admin-password='<choose-one>'

kubectl get secret cloudflare-apikey-secret -n homelab -o yaml | \
  sed 's/namespace: homelab$/namespace: homelab--paperless-ngx/' | \
  grep -vE '^\s+(resourceVersion|uid|creationTimestamp):' | kubectl apply -f -

kubectl apply -n homelab--paperless-ngx -f cert-issuers/issuer-prod--homelab-paperless-ngx.yaml
```

`admin-user` / `admin-password` only create the superuser on first start. You can delete
those keys afterwards.

## 3. Install

```bash
NS=homelab--paperless-ngx

helm upgrade --install homelab-app-data-postgresql--paperless-ngx ./lib/helm-chart-openebs-persistence \
  -n $NS -f config/externals/postgresql--paperless-ngx/pv.values.yaml
helm upgrade --install homelab-app-data-paperless-ngx ./lib/helm-chart-openebs-persistence \
  -n $NS -f config/externals/paperless-ngx/pv.values.yaml

helm upgrade --install postgresql--paperless-ngx oci://registry-1.docker.io/bitnamicharts/postgresql \
  -n $NS -f config/externals/postgresql--paperless-ngx/values.yaml

helm upgrade --install paperless-ngx ./apps/paperless-ngx \
  -n $NS -f config/externals/paperless-ngx/values.yaml

helm upgrade --install paperless-ngx-ingress ./lib/helm-chart-homelab-ingress-tls \
  -n $NS -f config/externals/paperless-ngx/ingress-tls.values.yaml
```

Check:

```bash
kubectl -n $NS get pods,pvc,certificate
kubectl -n $NS logs deploy/paperless-ngx -f
```

## Upgrade

Bump `image.tag` in `apps/paperless-ngx/values.yaml`, then:

```bash
helm upgrade paperless-ngx ./apps/paperless-ngx -n homelab--paperless-ngx \
  --reuse-values -f config/externals/paperless-ngx/values.yaml
```

## Notes

- DNS: point `paperless.mrsauravsahu.in` at the ingress, like the other subdomains.
- Drop files into `app-data/paperless-ngx/consume` on `pi` and Paperless ingests them.
- Backups: `kubectl -n homelab--paperless-ngx exec deploy/paperless-ngx -- document_exporter ../export`
  writes to `app-data/paperless-ngx/export`.
