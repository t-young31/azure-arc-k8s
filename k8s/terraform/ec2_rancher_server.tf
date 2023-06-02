resource "aws_instance" "rancher_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.medium"
  key_name      = aws_key_pair.ssh.key_name

  tags = {
    Name = "${var.aws_prefix}-rancher-server"
  }

  network_interface {
    network_interface_id = aws_network_interface.rancher_server.id
    device_index         = 0
  }

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

resource "aws_network_interface" "rancher_server" {
  subnet_id       = data.aws_subnet.public_playpen.id
  security_groups = [aws_security_group.allow_all_tls_from_deployer_ip.id]

  tags = {
    Name = "primary_network_interface"
  }
}

