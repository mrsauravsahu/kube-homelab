terraform {
  required_providers {
    ssh = {
      source = "loafoe/ssh"
      version = "2.3.0"
    }

    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "ssh" { }
provider "time" { }
