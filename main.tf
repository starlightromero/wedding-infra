resource "digitalocean_domain" "this" {
  name       = var.hostname
  ip_address = digitalocean_loadbalancer.this.ip
}

resource "digitalocean_project" "wedding" {
  name        = "Wedding"
  description = "A project for all digital wedding assets."
  purpose     = "Web Application"
  environment = "Production"
}

resource "digitalocean_project_resources" "this" {
  project = digitalocean_project.wedding.id
  resources = [
    digitalocean_domain.this.urn,
    digitalocean_loadbalancer.this.urn,
    digitalocean_kubernetes_cluster.this.urn
  ]
}

resource "digitalocean_firewall" "this" {
  name = "${var.cluster_name}-firewall"

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["75.128.58.244/32"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    source_load_balancer_uids = [digitalocean_loadbalancer.this.id]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "443"
    source_load_balancer_uids = [digitalocean_loadbalancer.this.id]
  }
}

resource "digitalocean_loadbalancer" "this" {
  name   = "${var.cluster_name}-lb"
  region = var.do_region

  #  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"
  }

  healthcheck {
    port     = 22
    protocol = "tcp"
  }
}

data "digitalocean_kubernetes_versions" "this" {
  version_prefix = "1."
}

resource "digitalocean_kubernetes_cluster" "this" {
  name          = "terraform-do-cluster"
  region        = var.do_region
  version       = data.digitalocean_kubernetes_versions.this.latest_version
  auto_upgrade  = true
  surge_upgrade = true

  node_pool {
    name       = "${var.cluster_name}-default-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 2
    max_nodes  = 9
  }
}
