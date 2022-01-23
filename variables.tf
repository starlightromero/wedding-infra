variable "do_token" {
  type        = string
  description = "Access Token for Digital Ocean"
}

variable "do_region" {
  type        = string
  description = "Digital Ocean region"
  default     = "sfo3"
}
