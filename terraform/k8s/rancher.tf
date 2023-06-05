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

  depends_on = [
    local_file.kube_config_server_yaml,
    aws_instance.rancher_server
  ]
}

resource "helm_release" "rancher_server" {
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

  depends_on = [
    helm_release.cert_manager,
  ]
}

resource "ssh_resource" "install_k3s" {
  host = local.server_public_ip
  commands = [
    "bash -c 'curl https://get.k3s.io | INSTALL_K3S_EXEC=\"server --node-external-ip ${local.server_public_ip} --node-ip ${local.server_internal_ip}\" INSTALL_K3S_VERSION=${local.rancher_kubernetes_version} sh -'"
  ]
  user        = local.server_username
  private_key = tls_private_key.global_key.private_key_pem
}

resource "ssh_resource" "retrieve_config" {
  depends_on = [
    ssh_resource.install_k3s
  ]
  host = local.server_public_ip
  commands = [
    "sudo sed \"s/127.0.0.1/${local.server_public_ip}/g\" /etc/rancher/k3s/k3s.yaml"
  ]
  user        = local.server_username
  private_key = tls_private_key.global_key.private_key_pem
}

# Initialize Rancher server
resource "rancher2_bootstrap" "admin" {
  depends_on = [
    helm_release.rancher_server
  ]

  provider = rancher2.bootstrap

  password  = var.rancher_server_password
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
  content  = ssh_resource.retrieve_config.result
}

resource "local_file" "kube_config_workload_yaml" {
  filename = "${path.root}/kube_config_workload.yaml"
  content  = rancher2_cluster_v2.quickstart_workload.kube_config
}
