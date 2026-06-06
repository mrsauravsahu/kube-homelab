# Affine

Self-hosted Affine at `notes.mrsauravsahu.in`.

## Prerequisites

- PVs and PVCs for postgres (5Gi) and storage (10Gi) must exist — apply via the `helm-chart-openebs-persistence` chart using `pv-postgres.values.yaml` and `pv-storage.values.yaml`.

## Deploy

### 1. Create namespace and copy Cloudflare secret

```bash
kubectl create namespace homelab-affine

kubectl get secret cloudflare-apikey-secret -n homelab -o yaml | \
  sed 's/namespace: homelab/namespace: homelab-affine/' | kubectl apply -f -
```

### 2. Apply cert issuer

```bash
kubectl apply -f molecules/cluster-resources/cert-issuers/issuer-prod--homelab-affine.yaml
```

### 3. Substitute env vars and install

```bash
# Run from repo root
AFFINE__DB_PASSWORD=<strong-password> bash env-substituter.sh molecules/cluster-resources/config/externals/affine/values.yaml

helm install affine ./molecules/cluster-resources/apps/affine \
  --namespace homelab-affine \
  -f molecules/cluster-resources/config/externals/affine/values.local.yaml
```

## Upgrade

```bash
# Run from repo root
AFFINE__DB_PASSWORD=<strong-password> bash env-substituter.sh molecules/cluster-resources/config/externals/affine/values.yaml

helm upgrade affine ./molecules/cluster-resources/apps/affine \
  --namespace homelab-affine \
  -f molecules/cluster-resources/config/externals/affine/values.local.yaml
```
