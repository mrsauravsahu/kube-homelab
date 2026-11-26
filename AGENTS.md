# AGENTS

Instructions for coding agents working in this repo (opencode, Claude Code, and others).
`CLAUDE.md` imports this file. Edit this file, not `CLAUDE.md`.

## How the cluster is managed

- **Helm only.** Every app is deployed with `helm upgrade --install` (plus some `kubectl apply`
  for cert issuers and secrets), run by hand against the cluster.
- **Terraform is not used anymore.** Don't run it or add `.tf` resources. The `*.tf` and `*.tftpl`
  files under `molecules/` are reference only. Read them for names, paths, and values, then turn
  them into helm values files (`*.values.yaml`).
- The repo's values often lag the live cluster (domain, image tags, TLS). Check live values first
  (`helm -n <ns> get values <release> -o yaml`), and use `--reuse-values` on upgrades unless you
  mean to replace them.
- Nodes: `pi` (holds the data drive), `pi5`, `msi-pc-linux`. ARM64 first, so pick images with arm64
  builds. `docs/tasks.md` tracks known cluster problems.

## Layout (`molecules/cluster-resources`)

| Path | What |
| --- | --- |
| `apps/<app>/` | Local helm charts for apps without a good upstream chart |
| `config/externals/<app>/values.yaml` | Values for upstream or local charts |
| `config/externals/<app>/ingress-tls.values.yaml` | Values for `lib/helm-chart-homelab-ingress-tls` |
| `config/externals/<app>/pv.values.yaml` | Values for `lib/helm-chart-openebs-persistence` |
| `cert-issuers/issuer-prod--homelab-<app>.yaml` | cert-manager Issuer (Cloudflare DNS01) per namespace |
| `lib/` | Shared charts: ingress, ingress-tls, openebs PV/PVC |

Run helm commands from `molecules/cluster-resources` so the `./lib` and `./apps` paths resolve.

## Adding an app

1. Namespace `homelab--<app>` (e.g. `homelab--paperless-ngx`). `--` joins a part to what it
   belongs to, as in `postgresql--<app>`. Older apps still use `homelab-<app>` (`homelab-immich`,
   `homelab-keycloak`) and will be migrated later; don't rename them as a side effect.
2. **Storage:** a `local` PV + PVC via `lib/helm-chart-openebs-persistence`, pinned to node `pi`,
   at `/homelab/drives/drive-2tb-1/app-data/<app>`. Release name `homelab-app-data-<app>`,
   PV `pv-homelab-app-data-<app>`, PVC `pvc-homelab-app-data-<app>`.
3. **Postgres:** one bitnami `postgresql` release per app, named `postgresql--<app>` (like
   `postgresql--idp`, `postgresql--keycloak`, `postgresql--immich`). Its data lives at
   `/homelab/drives/drive-2tb-1/app-data/postgresql--<app>` through its own PV/PVC
   (`pvc-homelab-app-data-postgresql--<app>`), set as `primary.persistence.existingClaim`.
   Bitnami images now live under `bitnamilegacy/`.
4. **The user creates host dirs.** `local` PVs don't create their paths. Document the
   `mkdir`/`chown` steps for the user to run on `pi` (bitnami postgres runs as uid 1001). Don't
   run them yourself.
5. **Ingress:** `lib/helm-chart-homelab-ingress-tls` + an Issuer. Copy `cloudflare-apikey-secret`
   from `homelab` into the new namespace.
6. Put deploy steps in a README next to the app (see `apps/paperless-ngx/README.md`).

## Secrets

- Never commit passwords, tokens, or keys. Read them from an existing secret (`existingSecret`,
  `secretKeyRef`) that the user creates with `kubectl create secret`.
- If a value file needs a secret inline, use a `{secret:APP__FIELD}` placeholder (uppercase,
  `[A-Z0-9_]`) and add the same key, empty, to `secrets.example.yaml`. All secret values live in
  one gitignored file, `secrets.yaml` at the repo root. Render with
  `./env-substituter.sh <file>` (writes `*.local.yaml`, gitignored). `./env-substituter.sh --check`
  must pass; `git grep -n '{secret:'` finds every placeholder.
- Passwords already leaked on branch `chore/local-stuff`. Don't copy values from it without
  removing the credentials.

## Cluster access for agents

- Use the read-only ServiceAccount from `docs/k8s-readonly-ai-serviceaccount.md`. It can't read
  Secrets or change anything.
- Don't run `helm install/upgrade/uninstall`, `kubectl apply/delete`, or anything else that changes
  the cluster unless the user asks. Give them the commands to run.

## Git workflow

- Work in a worktree at `w/<branch>` (branch name == dir name, e.g. `feat-paperless-ngx`), based
  on `origin/main`. `/w` is gitignored.
- Stage changes. Don't commit, push, or merge unless asked; the user opens the PR.
