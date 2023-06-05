resource "aws_instance" "example_node" {
  ami           = data.aws_ami.sles.id
  instance_type = "t3a.xlarge"
  key_name      = aws_key_pair.ssh.key_name

  subnet_id              = aws_subnet.rancher.id
  vpc_security_group_ids = [aws_security_group.allow_all_tls_from_deployer_ip.id]

  tags = {
    Name = "${var.aws_prefix}-rancher-node"
  }

  user_data = templatefile(
    "${path.module}/userdata_example_node.template",
    {
      register_command = rancher2_cluster_v2.quickstart_workload.cluster_registration_token.0.insecure_node_command
    }
  )

  #network_interface {
  #  network_interface_id = aws_network_interface.example_node.id
  #  device_index         = 0
  #}

  root_block_device {
    volume_size = 30 # GB
    volume_type = "gp3"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.ec2_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

#resource "aws_network_interface" "example_node" {
#  #subnet_id       = data.aws_subnet.public_playpen.id
#  subnet_id       = aws_subnet.rancher.id
#  security_groups = [aws_security_group.allow_all_tls_from_deployer_ip.id]
#
#  tags = {
#    Name = "primary_network_interface"
#  }
#}
