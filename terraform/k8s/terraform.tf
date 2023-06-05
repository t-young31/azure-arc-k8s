terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.0.0"
    }

    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
  }

  required_version = ">= 1.2.0"
}
