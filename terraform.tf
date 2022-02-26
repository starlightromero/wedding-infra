terraform {
  required_version = "1.1.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.8.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
  }
}
