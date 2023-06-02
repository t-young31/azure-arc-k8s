output "admin_server_password" {
  value     = random_password.rancher_server.result
  sensitive = true
}

output "rancher_server_url" {
  value = "https://${local.rancher_server_dns}"
}

output "rancher_node_ip" {
  value = aws_instance.rancher_server.public_ip
}

output "workload_node_ip" {
  value = aws_instance.example_node.public_ip
}
