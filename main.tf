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
    digitalocean_load_balancer.public.id,
    digitalocean_kubernetes_cluster.this.id
  ]
}

resource "digitalocean_firewall" "web" {
  name = "only-22-80-and-443"

  droplet_ids = [digitalocean_droplet.web.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["75.128.58.244/24"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
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

  droplet_ids = [digitalocean_kubernetes_cluster.this.nodes.*.droplet_id]
}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = "terraform-do-cluster"
  region  = "sfo3"
  version = "1.20.2-do.0"

  node_pool {
    name       = "default-pool"
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

resource "digitalocean_kubernetes_node_pool" "this" {
  cluster_id = digitalocean_kubernetes_cluster.this.id

  name       = "app-pool"
  size       = "s-2vcpu-4gb"
  tags       = ["application"]
  auto-scale = true
  min_nodes  = 1
  max_nodes  = 3
}
