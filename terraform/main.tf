module "aml" {
  source = "./aml"

  azure_suffix = var.azure_suffix
}

module "k8s" {
  source = "./k8s"

  aws_prefix              = var.aws_prefix
  rancher_server_password = random_password.rancher_server.result
}

# Password must be generated at the root level as outputing
# senstive values module->root is not allowed
resource "random_password" "rancher_server" {
  length           = 32
  lower            = true
  min_lower        = 5
  upper            = true
  min_upper        = 5
  numeric          = true
  min_numeric      = 5
  special          = true
  min_special      = 5
  override_special = "_%@"
}
