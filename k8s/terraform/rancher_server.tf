resource "aws_instance" "rancher_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "ty_test_tf_instance"
  }

  network_interface {
    network_interface_id = aws_network_interface.rancher_server.id
    device_index         = 0
  }

  root_block_device {
    volume_size = 30 # GB
    volume_type = "gp3"
  }
}

resource "aws_security_group" "rancher_server" {
  name        = "allow_ssh"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.playpen.id

  ingress {
    description      = "TLS"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_network_interface" "rancher_server" {
  subnet_id   = data.aws_subnet.public_playpen.id
  security_groups = [aws_security_group.rancher_server.id]

  tags = {
    Name = "primary_network_interface"
  }
}
