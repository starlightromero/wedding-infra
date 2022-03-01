# Wedding Infra

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.1.6 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | 2.17.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | 2.17.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [digitalocean_domain.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/domain) | resource |
| [digitalocean_droplet.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/droplet) | resource |
| [digitalocean_firewall.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/firewall) | resource |
| [digitalocean_loadbalancer.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/loadbalancer) | resource |
| [digitalocean_project.wedding](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/project) | resource |
| [digitalocean_project_resources.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/project_resources) | resource |
| [digitalocean_vpc.this](https://registry.terraform.io/providers/digitalocean/digitalocean/2.17.0/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the kubernetes cluster to create | `string` | `"wedding-app"` | no |
| <a name="input_do_region"></a> [do\_region](#input\_do\_region) | Digital Ocean region | `string` | `"sfo3"` | no |
| <a name="input_do_token"></a> [do\_token](#input\_do\_token) | Access Token for Digital Ocean | `string` | n/a | yes |
| <a name="input_hostname"></a> [hostname](#input\_hostname) | Hostname of website | `string` | `"charrington.xyz"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
