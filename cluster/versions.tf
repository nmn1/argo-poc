terraform {

  backend "local" {
    path = "terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.56.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "> 2.16.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "> 2.6.0"
    }
  }
}
