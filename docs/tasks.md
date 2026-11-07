# Tasks

Open follow-ups for kube-homelab.

## Cluster stability (2026-11-07) — do first

The API keeps dropping and `pi` carries almost everything.

- [ ] **`pi5` can't pull any image.** 107 of 110 pods there are `ImagePullBackOff` (argo-cd controller, loki, victoria-metrics, payobills parser, `svclb-ingress-nginx`), from every registry. Diagnose on `pi5`:
  ```sh
  docker pull rancher/klipper-lb:v0.4.9
  df -h / /var/lib/docker
  timedatectl | grep -E "Local time|synchronized"
  cat /etc/docker/daemon.json
  resolvectl query registry-1.docker.io
  sudo journalctl -u docker --since "1 hour ago" --no-pager | grep -iE "error|pull" | tail -10
  ```
- [ ] **`pi5` kubelet restarts** every 5–50 min with `NodePasswordValidationFailed: hash does not match`
- [ ] **etcd has only 2 members** (`pi`, `pi5`), so any stall on either takes the API down. Add a third server (e.g. `msi-pc-linux`) or run a single etcd on `pi5`
- [ ] **`pi` is out of memory:** 70 MB free, 100 MB swap full, `kswapd0` at 32%, ~50% system CPU, load ~11 on 4 cores. `k3s-server` restarts under it. Stopgap zram:
  ```sh
  sudo apt install zram-tools
  echo -e "ALGO=zstd\nPERCENT=50" | sudo tee /etc/default/zramswap
  sudo systemctl restart zramswap
  ```
- [ ] `msi-pc-linux` NotReady since 2026-10-31
- [ ] User `systemd` for `pi` has 29h CPU this boot: `systemctl --user list-units --state=running`
- [ ] Later: move k3s from Docker to its built-in containerd (`dockerd` + `containerd` ≈ 38% CPU on `pi`)

## Immich performance (blocked on `pi5` image pulls)

Biggest memory on `pi`: prometheus-server 1.1 GB, immich-server 1.08 GB (api + 3 workers), keycloak 527 MB, immich-machine-learning 227 MB.

- [ ] Move `immich-machine-learning` to `pi5` (doesn't need `/data`); give it a model cache volume on `pi5`
- [ ] Move `prometheus-server` to `pi5`. Its `local-path` PVC is pinned to `pi`, so metrics history resets
- [ ] Cut Immich workers from 3 to 1 (~500–700 MB). Repo values are stale (live: chart `immich-0.10.3`, `v2.6.1`; repo: `v1.119.0`, no worker containers). Get live values first:
  ```sh
  helm -n homelab-immich get values immich -o yaml
  ```
- [ ] Consider moving `drive-2tb-1` to `pi5` (better USB power budget), then re-pin its PVs to `pi5`

## Immich recovery follow-ups (2026-11-06)

- [x] Postgres recovered: empty `pg_logical/replorigin_checkpoint` moved aside, clean `pg_dumpall` taken
- [ ] Recreate the externals PV with the `Pictures` path (helm steps: scale server to 0, delete PVC + PV, `helm upgrade --install homelab-app-data-immich-externals ./lib/helm-chart-openebs-persistence`)
- [ ] External library `Pi`: add `/externals`, remove `/externals/2017|2018|2026`, then scan
- [ ] Affine Postgres has the same `replication checkpoint has wrong magic 0` crash; apply the same fix
- [ ] Back up `Pictures` off `drive-2tb-1` (only copy, on the drive that lost power)
- [ ] Rotate the DB passwords exposed on public branch `chore/local-stuff`, then delete that branch

## Certificates / Cloudflare (2026-11-07)

- [x] Reissued with the working token: immich, grafana, hajimari, minio, nocodb, owncloud (now on the TLS ingress chart)
- [ ] Copy the token into `homelab-affine`, `homelab-n8n`, `homelab-openwebui`, `argo-cd`
- [ ] Update the token at its source so a redeploy doesn't restore the old one
- [ ] Owncloud HTTPS fails over VPN but works via `192.168.200.200`. Check which node owns `100.114.222.43` (`tailscale status`); `pi5`'s `svclb` is broken

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
