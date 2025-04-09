# kube-homelab

A Kubernetes based setup to run a home server.

## Getting started


To start with, you can use a Rasperry Pi or if you want to rock your own setup from old hardware, use an old laptop that you have lying around. Do note, this repo is ARM 64 first, so some images might not work. Here are some Amazon links to buy the hardware you need to get started.

### Hardware links

Here are some links to the hardware I'm using. Do note these are affiliate links.

- [Raspberry Pi 4 for compute](https://www.amazon.in/Raspberry-Pi-Cortex-A76-Computer-RPI5-8GB-SINGLE/dp/B0CK2FCG1K?crid=EKBEAN3NPRMC&dib=eyJ2IjoiMSJ9.elFH5y0l5x9aR3GfFvFqYY_JXnW6E_F5Z5YSKW5wM_9nwP5FBIxx-Jcf9zliTMNa3kDMrGmsqRcAhlvSN5DpipOaZb0MUEuDNOpa36R_OnwGw4zTbhOWkLmX9zbscB66_DwwRzv5IlCSPO1RYnLASbtGrd2Hjx3RWndsM7ukjVP1iUgk8_1qLfaV4K2iW-LzT2rn6dpzVqfr92tMdFYwx8HnrJ8ArKDsVgogVWpzi64.EpCKj_jvi4HxDmy47aEJggqC4zWiJSRs6Ju9sEJIg4A&dib_tag=se&keywords=raspberry+pi+5+8gb&nsdOptOutParam=true&qid=1744222175&sprefix=raspberry%2Caps%2C291&sr=8-2&linkCode=ll1&tag=withsahu-21&linkId=f9f43728ee08d0a17d7a1c6113df613d&language=en_IN&ref_=as_li_ss_tl) - this can scale horizontally for compute
- [Data Storage HDD](https://www.amazon.in/Passport-Portable-External-Drive-Black/dp/B07VTFN6HM?crid=3NVTLLDOLACP5&dib=eyJ2IjoiMSJ9.dJYp26oYdVWMB4Dh258mLxkBu4GDQGYu5zfkFMnRlpOIMTQjfJEfgBkeozy-Vb7ljOykLPac9rl_V3dbfZH7ne1n0fLsFgp4j-sSa01oDCOI8DekSHhOrdAvitNEYn-6uhD-74uDPteo81aOLhwOeF_nlvfWHjF0wAjOdcLueso5GjgozA1kSs5J2W8I_XfVId_Mjo-Bpo_y21tzSiciNO3YIUrpzoOKZg1LdlfsPvk.bQghFuZg0piRLweqhmcUcNFDlIU5cbCWQgSo2-peD7Q&dib_tag=se&keywords=wd+ssd+external&nsdOptOutParam=true&qid=1744222464&sprefix=wd+ssd+extern%2Caps%2C510&sr=8-17&linkCode=ll1&tag=withsahu-21&linkId=24996123e7343a8fa8b7f1b79c56bc78&language=en_IN&ref_=as_li_ss_tl) - I'm using external drives but feel free to use internal drives and connect with SATA adapters
- [Data Storage SSD](https://www.amazon.in/Portable-Protection-Compatible-Warranty-SDSSDE30-1T00-G26/dp/B0C5JQ68FY/ref=sr_1_6?crid=3NVTLLDOLACP5&dib=eyJ2IjoiMSJ9.dJYp26oYdVWMB4Dh258mLxkBu4GDQGYu5zfkFMnRlpOIMTQjfJEfgBkeozy-Vb7ljOykLPac9rl_V3dbfZH7ne1n0fLsFgp4j-sSa01oDCOI8DekSHhOrdAvitNEYn-6uhD-74uDPteo81aOLhwOeF_nlvfWHjF0wAjOdcLueso5GjgozA1kSs5J2W8I_XfVId_Mjo-Bpo_y21tzSiciNO3YIUrpzoOKZg1LdlfsPvk.bQghFuZg0piRLweqhmcUcNFDlIU5cbCWQgSo2-peD7Q&dib_tag=se&keywords=wd%2Bssd%2Bexternal&nsdOptOutParam=true&qid=1744222464&sprefix=wd%2Bssd%2Bextern%2Caps%2C510&sr=8-6&th=1) - this is the second type of drive, it's expensive but it's SSD so there aren't any moving parts and more compact.
- [RJ45 cable](https://www.amazon.in/TECH-X-Ethernet-Internet-Computer-cable-Grey/dp/B09PJHW5CY?crid=OGRLEGVOX247&dib=eyJ2IjoiMSJ9.ltdP5-SAQ6J-DhWkMqFH8WarlrIN4qPG2gLfvDh8a2990gVQz5iXK5_K8o-VvR1aiiqraGS02uwPvI15ulYIp48hyxRf-WFBlAxTqJIG5dsEUzYjRvUjUyVU5UzTRoi5yBSmFwXAZzr3SEXgMko5wlGY-t5jES8R3hKwJ3bizz6fr1B4ff_Vtz4hzSKGtGI4enVD0k5Vpzhf8u6MzqIhd-DC8ZACTB0KSDUS2asnZvI.orLCpPyprtqFNbtChPHZqbf0B78PoT2C1j9iCR4KO9E&dib_tag=se&keywords=rj45%2Bconnector%2B1m&qid=1744222622&sprefix=rj45%2Bconnector%2B1m%2Caps%2C250&sr=8-1-spons&sp_csd=d2lkZ2V0TmFtZT1zcF9hdGY&th=1&linkCode=ll1&tag=withsahu-21&linkId=5081bcf4a0ac783c3079979a9d9ce71b&language=en_IN&ref_=as_li_ss_tl) - would suggest using wired connection between devices, but WiFi can be a starting point



## Architecture

The architecture is evolving as this is an active project I'm working on, but her's the basic idea. 

The approach is layered and layers depend on one or more installed components from the layer below.

![Architecure Diagram](./docs/images/kube-homelab.drawio.svg)

# Learn more

I had also created a video where I show how I set the homelab up for my use. 

[<img src="https://user-images.githubusercontent.com/9134050/212525414-02a03a7e-f1f6-4b51-a5a6-c4a49c994f89.png">](https://www.youtube.com/watch?v=LfBcERF6qw4)

### Requirements



- Linux nodes (a VM, Raspberry PI, Tower PC)
- Docker installed on the node
- systemd configured on the nodes (this is because k3s runs as a systemd service)
- ssh configured with a keypair - password based authentication is not supported

### Terminology

- Any reusable part of this project will be an atom.
- Various parts of the setup are put into different terraform modules to be used as a workspace, each. This is also called a molecule.

### Software to run the terraform molecules

- terraform installed on the agent which will execute terraform (can be the node itself as well) - currently `required_version = ">=1.3.0"`
- [terraform-backend-git](https://github.com/plumber-cd/terraform-backend-git) if you want to use a git repository to store terraform state. 

### Order of molecules

1. [k3s](./molecules/k3s/readme.md)
2. [cluster-resources](./molecules/cluster-resources/readme.md)

### Running the molecules

#### Only if you are using a remote backend
- Fill `.envrc` with all the required values. Place one .envrc in each molecule, this will help segregate their values and also because each molecule should have its own state file, so `export TF_BACKEND_GIT_GIT_STATE=` will change. I use `state-<MOLECULE_NAME>.json` as the pattern
- Import all environment variables by running `. .envrc` in the directory of the molecule
- Run the terraform init as follows - `terraform init -backend-config="address=${BACKEND}" -backend-config="lock_address=${BACKEND}" -backend-config="unlock_address=${BACKEND}"` the BACKEND env var is setup based on the other env vars in .envrc

#### If you use local backend
- Remove the `backend "http" {}` from all molecules and init the molecules `terraform init`
- Now run `terraform apply -var-file=inputs.tfvars` (modify the inputs.tfvars as per your liking)

Read any specific requirements per molecule in their readme.

### Test bed

I'm using Raspberry Pi 4 and Raspberry Pi 5 as the nodes on my Kubernetes cluster and all testing is done on this setup.

- Raspberry Pi 4 +  Raspberry Pi 5
- Ubuntu Server 22.04
- docker 20.10.12
