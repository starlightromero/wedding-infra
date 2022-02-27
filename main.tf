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
    digitalocean_kubernetes_cluster.this.urn,
    digitalocean_database_cluster.this.urn
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

resource "digitalocean_vpc" "this" {
  name     = "${var.cluster_name}-vpc"
  region   = var.do_region
  ip_range = "10.16.32.0/24"
}

resource "digitalocean_certificate" "this" {
  name    = "${var.cluster_name}-cert"
  type    = "lets_encrypt"
  domains = [var.hostname]
}

resource "digitalocean_loadbalancer" "this" {
  name     = "${var.cluster_name}-lb"
  region   = var.do_region
  vpc_uuid = digitalocean_vpc.this.id

  #  redirect_http_to_https = true

  forwarding_rule {
    entry_port     = 80
    entry_protocol = "http"

    target_port     = 80
    target_protocol = "http"

    certificate_name = digitalocean_certificate.this.name
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
  name     = var.cluster_name
  region   = var.do_region
  vpc_uuid = digitalocean_vpc.this.id

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

resource "digitalocean_database_firewall" "this" {
  cluster_id = digitalocean_database_cluster.this.id

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.this.id
  }
}

resource "digitalocean_database_cluster" "this" {
  name   = "${var.cluster_name}-db"
  region = var.do_region

  private_network_uuid = digitalocean_vpc.this.id

  engine     = "mongodb"
  version    = "4"
  size       = "db-s-1vcpu-1gb"
  node_count = 1

  maintenance_window {
    day  = "monday"
    hour = "06:00"
  }
}
