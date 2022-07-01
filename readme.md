# homelab

A Kubernetes based setup to run a home server.

## prerequisites

- A Kubernetes cluster running on the server.

## test bed

I'm using my Raspberry Pi 4 as my home server and all testing is done on it. 

- Raspberry Pi 4
- Ubuntu Server 22.04
- docker 20.10.12
- k3s v1.23.8+k3s1 (53f2d4e7)
- data stored on external drive - mounted at `/mnt/my-passport-drive`

## apps

### jellyfin

Jellyfin is a media server. Play all your local video content.

### wip - pihole (looking at other alternatives too)

Local DNS

### wip - nextcloud

File Sharing
