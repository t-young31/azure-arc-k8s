terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.0.4"
    }
    http = {
      source = "hashicorp/http"
      version = "3.3.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-2"  # London
}
