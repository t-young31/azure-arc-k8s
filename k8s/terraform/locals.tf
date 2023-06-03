locals {
  deployer_ip                = data.http.deployer_ip.response_body
  ec2_username               = "ubuntu"
  cert_manager_version       = "1.10.0"
  rancher_version            = "2.7.3"
  rancher_kubernetes_version = "v1.24.13+k3s1"
  rancher_helm_repository    = "https://releases.rancher.com/server-charts/latest"
  rancher_server_dns         = join(".", ["rancher", aws_instance.rancher_server.public_ip, "sslip.io"])

  server_public_ip   = aws_instance.rancher_server.public_ip
  server_internal_ip = aws_instance.rancher_server.private_ip
  server_username    = local.ec2_username

  workload_kubernetes_version = "v1.24.13+rke2r1"
  workload_cluster_name       = "k3s-aws-workload"
}
