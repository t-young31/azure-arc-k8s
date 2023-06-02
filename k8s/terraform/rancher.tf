resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  chart            = "https://charts.jetstack.io/charts/cert-manager-v${local.cert_manager_version}.tgz"
  namespace        = "cert-manager"
  create_namespace = true
  wait             = true

  set {
    name  = "installCRDs"
    value = "true"
  }
}

resource "helm_release" "rancher_server" {
  depends_on = [
    helm_release.cert_manager,
  ]

  name             = "rancher"
  chart            = "${local.rancher_helm_repository}/rancher-${local.rancher_version}.tgz"
  namespace        = "cattle-system"
  create_namespace = true
  wait             = true

  set {
    name  = "hostname"
    value = local.rancher_server_dns
  }

  set {
    name  = "replicas"
    value = "1"
  }

  set {
    name  = "bootstrapPassword"
    value = "admin"
  }
}

resource "ssh_resource" "server_init" {
  for_each    = local.server_init_commands
  host        = local.server_public_ip
  commands    = [each.value]
  user        = local.server_username
  private_key = tls_private_key.global_key.private_key_pem
}

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

# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  depends_on = [
    helm_release.rancher_server
  ]

  provider = rancher2.bootstrap

  password  = random_password.rancher_server.result
  telemetry = true
}

# Create custom managed cluster for quickstart
resource "rancher2_cluster_v2" "quickstart_workload" {
  provider = rancher2.admin

  name               = local.workload_cluster_name
  kubernetes_version = local.workload_kubernetes_version
}

# Save local files for interacting from local
resource "local_file" "kube_config_server_yaml" {
  filename = "${path.root}/kube_config_server.yaml"
  content  = ssh_resource.server_init["retrieve_config"].result
}

resource "local_file" "kube_config_workload_yaml" {
  filename = "${path.root}/kube_config_workload.yaml"
  content  = rancher2_cluster_v2.quickstart_workload.kube_config
}
