resource "digitalocean_domain" "this" {
  name       = "charrington.xyz"
  ip_address = digitalocean_loadbalancer.public.ip
}

resource "digitalocean_project" "wedding" {
  name        = "wedding"
  description = "A project for all digital wedding assets."
  purpose     = "Web Application"
  environment = "Production"
}

resource "digitalocean_project_resources" "this" {
  project = digitalocean_project.wedding.id
  resources = [
    digitalocean_loadbalancer.public.id,
    digitalocean_kubernetes_cluster.this.id
  ]
}

resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = digitalocean_kubernetes_cluster.this.node_pool[*].droplet_id

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["75.128.58.244/24"]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "80"
    source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
  }

  inbound_rule {
    protocol                  = "tcp"
    port_range                = "443"
    source_load_balancer_uids = [digitalocean_loadbalancer.public.id]
  }
}

resource "digitalocean_loadbalancer" "public" {
  name   = "loadbalancer-1"
  region = "nyc3"

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

  droplet_ids = digitalocean_kubernetes_cluster.this.node_pool[0].droplet_id
}

resource "digitalocean_kubernetes_cluster" "this" {
  name         = "terraform-do-cluster"
  region       = "sfo3"
  version      = "1.20.2-do.0"
  auto_upgrade = true

  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 3
  }
}
