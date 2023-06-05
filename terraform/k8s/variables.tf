variable "aws_prefix" {
  type = string
}

variable "rancher_server_password" {
  type      = string
  sensitive = true
}
