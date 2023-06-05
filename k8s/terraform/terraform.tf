terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.3.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.0.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.10.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
  }

  required_version = ">= 1.2.0"
}