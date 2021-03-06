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
    digitalocean_droplet.this.urn
  ]
}

resource "digitalocean_vpc" "this" {
  name     = "${var.name}-vpc"
  region   = var.do_region
  ip_range = "10.16.32.0/24"
}

resource "digitalocean_certificate" "this" {
  name    = "${var.name}-cert"
  type    = "lets_encrypt"
  domains = [var.hostname]
}

resource "digitalocean_loadbalancer" "this" {
  name     = "${var.name}-lb"
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

  droplet_ids = [digitalocean_droplet.this.id]
}

resource "digitalocean_droplet" "this" {
  name     = "${var.name}-droplet"
  region   = var.do_region
  vpc_uuid = digitalocean_vpc.this.id

  image    = "ubuntu-20-04-x64"
  size     = "s-1vcpu-1gb"
  ssh_keys = ["d1:f8:9a:7d:24:c1:c1:b5:70:9a:fa:3c:3f:69:d4:b5"]
}
