# Read-only ServiceAccount for an AI agent

A kubeconfig that lets an agent inspect the cluster. It can't change anything, read Secrets, exec into pods or port-forward.

## 1. Create the account and roles

```yaml
# ai-readonly.yaml
apiVersion: v1
kind: Namespace
metadata: { name: ai-agent }
---
apiVersion: v1
kind: ServiceAccount
metadata: { name: ai-readonly, namespace: ai-agent }
---
# Built-in "view": get/list/watch on namespaced resources, excludes Secrets
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata: { name: ai-readonly-view }
roleRef: { apiGroup: rbac.authorization.k8s.io, kind: ClusterRole, name: view }
subjects: [{ kind: ServiceAccount, name: ai-readonly, namespace: ai-agent }]
---
# Cluster-scoped reads that "view" doesn't cover
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata: { name: ai-readonly-cluster }
rules:
- apiGroups: ["", storage.k8s.io, networking.k8s.io, apiextensions.k8s.io, metrics.k8s.io]
  resources: [nodes, persistentvolumes, namespaces, storageclasses, ingressclasses, customresourcedefinitions, pods]
  verbs: [get, list, watch]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata: { name: ai-readonly-cluster }
roleRef: { apiGroup: rbac.authorization.k8s.io, kind: ClusterRole, name: ai-readonly-cluster }
subjects: [{ kind: ServiceAccount, name: ai-readonly, namespace: ai-agent }]
```

Apply: `kubectl apply -f ai-readonly.yaml`

## 2. Build a separate kubeconfig with a short-lived token

Paste as-is into a shell whose `KUBECONFIG` points at your **admin** config. It writes `~/.kube/ai-readonly.yaml` and leaves your admin config untouched. It uses plain `kubectl` (the `k` alias isn't available in pasted snippets) and has no inline comments (zsh rejects them without `setopt interactivecomments`). Rerun it to refresh an expired token.

```sh
READONLY_KUBECONFIG="$HOME/.kube/ai-readonly.yaml"
CA_CERT_FILE="$(mktemp)"
CLUSTER_NAME="$(kubectl config view --minify -o jsonpath='{.contexts[0].context.cluster}')"
API_SERVER="$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')"
kubectl config view --minify --flatten -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d > "$CA_CERT_FILE"
SA_TOKEN="$(kubectl -n ai-agent create token ai-readonly --duration=8h)"
kubectl --kubeconfig "$READONLY_KUBECONFIG" config set-cluster "$CLUSTER_NAME" --server="$API_SERVER" --certificate-authority="$CA_CERT_FILE" --embed-certs
kubectl --kubeconfig "$READONLY_KUBECONFIG" config set-credentials ai-readonly --token="$SA_TOKEN"
kubectl --kubeconfig "$READONLY_KUBECONFIG" config set-context ai-readonly --cluster="$CLUSTER_NAME" --user=ai-readonly
kubectl --kubeconfig "$READONLY_KUBECONFIG" config use-context ai-readonly
chmod 600 "$READONLY_KUBECONFIG"
rm -f "$CA_CERT_FILE"
unset SA_TOKEN
KUBECONFIG="$READONLY_KUBECONFIG" kubectl get ns
```

Hand the agent `KUBECONFIG=~/.kube/ai-readonly.yaml`, never your admin config.

## 3. Verify

Run in the same admin shell (`--as` needs impersonate rights; the service account itself would get Forbidden). Expected: every line in the loop says `no`, `get pods` says `yes`, the `grep secrets` prints nothing, and `--list` shows only read verbs plus `selfsubject*reviews [create]` (default, harmless).

```sh
SERVICE_ACCOUNT="system:serviceaccount:ai-agent:ai-readonly"
for check in "get secrets" "list secrets" "create pods" "create pods/exec" "patch deployments" "delete pvc" "create serviceaccounts/token" "update configmaps"; do
  action="${check%% *}"
  resource="${check#* }"
  echo "$check: $(kubectl auth can-i "$action" "$resource" -A --as="$SERVICE_ACCOUNT")"
done
kubectl auth can-i get pods -A --as="$SERVICE_ACCOUNT"
kubectl get clusterrole view -o yaml | grep -n secrets
kubectl auth can-i --list --as="$SERVICE_ACCOUNT" | grep -vE '\[(get|list|watch|get list watch|get list|list watch)\]'
```

## Notes

- **The token expires** after `--duration`. Rerun step 2 (admin shell) to issue a new one. To revoke at once, run `kubectl delete sa ai-readonly -n ai-agent`.
- **`helm list`/`helm get` won't work.** Helm stores releases in Secrets. The agent should use `kubectl get` on deployments, pods and so on.
- **`view` still allows** ConfigMaps, `pods/log` and env values written into pod specs. Don't put credentials in those.
- **Not covered:** the files on PVs (your photos). RBAC only exposes API objects, not volume data.
