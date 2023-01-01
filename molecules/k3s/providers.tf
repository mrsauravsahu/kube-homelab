terraform {
  required_providers {
    ssh = {
      source  = "loafoe/ssh"
      version = "2.3.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }

    remote = {
      source  = "tenstad/remote"
      version = "0.1.1"
    }
  }

  backend "http" {
    address        = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-k3s.json"
    lock_address   = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-k3s.json"
    unlock_address = "http://localhost:6061?type=git&repository=https://github.com/mrsauravsahu/tfstate-homelab&ref=main&state=state-k3s.json"
  }
}

provider "ssh" {}
provider "time" {}
provider "remote" {}
