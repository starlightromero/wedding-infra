provider "digitalocean" {
  token = var.do_token
}

data "digitalocean_certificate" "wedding" {
  name = "example"
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.this.endpoint
  token = digitalocean_kubernetes_cluster.this.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.this.endpoint
    token = digitalocean_kubernetes_cluster.this.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
    )
  }
}
