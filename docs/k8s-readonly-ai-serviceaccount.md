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

Apply: `k apply -f ai-readonly.yaml`

## 2. Build a separate kubeconfig with a short-lived token

```sh
CL=$(k config view --minify -o jsonpath='{.contexts[0].context.cluster}')
SERVER=$(k config view --minify -o jsonpath='{.clusters[0].cluster.server}')
k config view --minify --raw -o jsonpath='{.clusters[0].cluster.certificate-authority-data}' | base64 -d > /tmp/ca.crt
TOKEN=$(k -n ai-agent create token ai-readonly --duration=8h)
KC=~/.kube/ai-readonly.yaml   # never export KUBECONFIG here: --as checks need your admin config
k --kubeconfig $KC config set-cluster "$CL" --server="$SERVER" --certificate-authority=/tmp/ca.crt --embed-certs
k --kubeconfig $KC config set-credentials ai-readonly --token="$TOKEN"
k --kubeconfig $KC config set-context ai-readonly --cluster="$CL" --user=ai-readonly
k --kubeconfig $KC config use-context ai-readonly; chmod 600 $KC
```

Hand the agent `KUBECONFIG=~/.kube/ai-readonly.yaml`, never your admin config.

## 3. Verify

Run with your **admin** kubeconfig (`--as` needs impersonate rights; the SA gets Forbidden, which is expected). Then confirm as the SA: `KUBECONFIG=~/.kube/ai-readonly.yaml k get pods -A`.

```sh
SA=system:serviceaccount:ai-agent:ai-readonly
printf '%s\n' "get secrets" "list secrets" "create pods" "create pods/exec" "patch deployments" \
  "delete pvc" "create serviceaccounts/token" "update configmaps" |
while read -r verb res; do echo "$verb $res: $(k auth can-i "$verb" "$res" -A --as=$SA)"; done  # all "no"
k auth can-i get pods -A --as=$SA                          # yes
k get clusterrole view -o yaml | grep -n secrets           # must print nothing
k auth can-i --list --as=$SA | grep -vE '\[(get|list|watch|get list watch|get list|list watch)\]' # only header + selfsubject*reviews [create] (default, harmless)
```

## Notes

- **The token expires** after `--duration`. Rerun step 2's `create token` line to issue a new one. To revoke at once, run `k delete sa ai-readonly -n ai-agent`.
- **`helm list`/`helm get` won't work.** Helm stores releases in Secrets. The agent should use `k get` on deployments, pods and so on.
- **`view` still allows** ConfigMaps, `pods/log` and env values written into pod specs. Don't put credentials in those.
- **Not covered:** the files on PVs (your photos). RBAC only exposes API objects, not volume data.
