# Tasks

Open follow-ups for kube-homelab.

## OwnCloud upload limits (2026-11-05)

Uploads failed on ingress-nginx's default 1 MB body limit. Fixed by adding body-size annotations to `owncloud-ingress`. Most uploads now work.

- [x] Add ingress annotations: `proxy-body-size: "0"`, `proxy-request-buffering: "off"`, read/send timeouts `600`
  - `molecules/cluster-resources/config/externals/owncloud/ingress.values.tftpl`
- [x] Apply: `helm upgrade owncloud-ingress ./lib/helm-chart-homelab-ingress -n homelab --reuse-values -f /tmp/oc-ing.yaml`
- [x] Add `OWNCLOUD_MAX_UPLOAD` env (`.Values.owncloud.maxUpload`, default `20G`)
  - `molecules/cluster-resources/apps/owncloud/templates/deployment.yaml`
- [ ] Test an upload over 100 MB. If it fails with an owncloud size error:
  ```sh
  helm upgrade owncloud ./apps/owncloud -n homelab --reuse-values
  k -n homelab rollout status deploy/owncloud
  ```
- [ ] Commit on branch `fix-owncloud-upload-limit` (based on latest `main`), push, open a PR
- [ ] If uploads fail again, check the controller logs:
  ```sh
  k -n ingress-nginx logs deploy/ingress-nginx-controller --tail=200 | grep -iE "too large|413"
  ```

## Notes

- Deploys use `helm` directly. Terraform is no longer run, so `.tftpl` files are reference only.
- Always pass `--reuse-values`. The repo's values files lag the cluster (domain, image tag, TLS).
- Nextcloud has the same 1 MB ingress default and a stray `k` typo in `trusted_domains` (`config/externals/nextcloud/values.yaml`). Fix those if you use it.
