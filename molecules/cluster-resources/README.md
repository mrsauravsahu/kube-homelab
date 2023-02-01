# cluster-resources

molecule to setup k3s servers

## setup

The host's Kubernetes API should be accessible and its kubeconfig file should be on the host which runs terraform.

If you continuing this molecule after the `k3s` molecule, you can get the kubeconfig from the `k3s` molecule's output.

Run this command in the `k3s` folder substituting the ip of the host

```
$ pwd

homelab/molecules/k3s

$ terraform output -json | jq -r '.kubeconfig.value."127.0.0.1"' > ../../config/127.0.0.1.kubeconfig
```

This can be done by copying the your public ssh key-pair into the `~/.ssh/authorized_keys` file on the server.
