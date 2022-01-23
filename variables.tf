variable "do_token" {
  type        = string
  description = "Access Token for Digital Ocean"
}

variable "do_region" {
  type        = string
  description = "Digital Ocean region"
  default     = "sfo3"
}

variable "cluster_name" {
  type        = string
  description = "The name of the kubernetes cluster to create"
  default     = "wedding-app"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email for letsencrypt"
  default     = "starlightromero@protonmail.com"
}

variable "hostname" {
  type        = string
  description = "Hostname of website"
  default     = "charrington.xyz"
}
