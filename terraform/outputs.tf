output "rancher_server_password" {
  value     = random_password.rancher_server.result
  sensitive = true
}

output "rancher_server_url" {
  value = module.k8s.rancher_server_url
}

output "rancher_node_ip" {
  value = module.k8s.rancher_node_ip
}

output "workload_node_ip" {
  value = module.k8s.workload_node_ip
}
