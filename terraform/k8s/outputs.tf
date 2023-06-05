output "rancher_server_url" {
  value = "https://${local.rancher_server_dns}"
}

output "rancher_node_ip" {
  value = aws_instance.rancher_server.public_ip
}

output "workload_node_ip" {
  value = aws_instance.example_node.public_ip
}

output "workload_ec2_id" {
  value = aws_instance.example_node.id
}
