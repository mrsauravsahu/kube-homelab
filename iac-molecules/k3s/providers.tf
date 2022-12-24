terraform {
  experiments = [module_variable_optional_attrs]

 required_providers {
    ssh = {
      source = "loafoe/ssh"
      version = "2.3.0"
    }
  }
}

provider "ssh" { }
