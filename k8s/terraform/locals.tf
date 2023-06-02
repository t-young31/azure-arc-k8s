locals {
  deployer_ip                = data.http.deployer_ip.response_body
  ec2_username               = "ec2-user"
  cert_manager_version       = "1.12.1"
  rancher_version            = "2.7.4"
  rancher_kubernetes_version = "v1.24.13+k3s1"
  rancher_helm_repository    = "https://releases.rancher.com/server-charts/latest"
  rancher_server_dns         = join(".", ["rancher", aws_instance.rancher_server.public_ip, "sslip.io"])

  server_public_ip   = aws_instance.rancher_server.public_ip
  server_internal_ip = aws_instance.rancher_server.private_ip
  server_username    = local.ec2_username

  server_init_commands = {
    "install_k3s" : "bash -c 'curl https://get.k3s.io | INSTALL_K3S_EXEC=\"server --node-external-ip ${local.server_public_ip} --node-ip ${local.server_internal_ip}\" INSTALL_K3S_VERSION=${local.rancher_kubernetes_version} sh -'",
    "retrieve_config" : "sudo sed \"s/127.0.0.1/${local.server_public_ip}/g\" /etc/rancher/k3s/k3s.yaml"
  }

  workload_kubernetes_version = "v1.24.13+rke2r1"
  workload_cluster_name       = "k3s-aws-workload"
}
