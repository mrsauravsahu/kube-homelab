# homelab

A Kubernetes based setup to run a home server.

## getting started

I had also created a video where I show how I set the homelab up for my use. 

[<img src="https://user-images.githubusercontent.com/9134050/212525414-02a03a7e-f1f6-4b51-a5a6-c4a49c994f89.png">](https://www.youtube.com/watch?v=LfBcERF6qw4)

### requirements

- Linux nodes (a VM, Raspberry PI, Tower PC)
- Docker installed on the node
- systemd configured on the nodes (this is because k3s runs as a systemd service)
- ssh configured with a keypair - password based authentication is not supported

### terminology

- Any reusable part of this project will be an atom.
- Various parts of the setup are put into different terraform modules to be used as a workspace, each. This is also called a molecule.

### software to run the terraform molecules

- terraform installed on the agent which will execute terraform (can be the node itself as well) - currently `required_version = ">=1.3.0"`
- [terraform-backend-git](https://github.com/plumber-cd/terraform-backend-git) if you want to use a git repository to store terraform state. 

### order of molecules

1. [k3s](./molecules/k3s/readme.md)
2. [cluster-resources](./molecules/cluster-resources/readme.md)

### running the molecules

#### Only if you are using a remote backend
- Fill `.envrc` with all the required values. Place one .envrc in each molecule, this will help segregate their values and also because each molecule should have its own state file, so `export TF_BACKEND_GIT_GIT_STATE=` will change. I use `state-<MOLECULE_NAME>.json` as the pattern
- Import all environment variables by running `. .envrc` in the directory of the molecule
- Run the terraform init as follows - `terraform init -backend-config="address=${BACKEND}" -backend-config="lock_address=${BACKEND}" -backend-config="unlock_address=${BACKEND}"` the BACKEND env var is setup based on the other env vars in .envrc

#### If you use local backend
- Remove the `backend "http" {}` from all molecules and init the molecules `terraform init`
- Now run `terraform apply -var-file=inputs.tfvars` (modify the inputs.tfvars as per your liking)

Read any specific requirements per molecule in their readme.

### test bed

I'm using my Raspberry Pi 4 as my home server and all testing is done on it. 

- Raspberry Pi 4
- Ubuntu Server 22.04
- docker 20.10.12

## apps

### jellyfin

Jellyfin is a media server. Play all your local video content.

### pihole (looking at other alternatives too)

Local DNS

### nextcloud

File Sharing

## setting up your machine

You can either use [k3d](https://k3d.io/) to try out locally, or like I am, using a server.
I have k3s installed on my Raspberry Pi 4.

### k3s setup

Run the following to setup the cluster.

```bash
$ curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION='v1.21.14+k3s1' sh -
```

Now you can run `terraform -chdir=iac plan` to check what's getting installed.

Finally, run `terraform -chdir=iac apply --auto-approve` to install everything.

