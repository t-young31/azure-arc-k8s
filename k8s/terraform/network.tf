resource "aws_security_group" "allow_all_tls_from_deployer_ip" {
  name        = "${var.aws_prefix}-allow-all-from-deployer-ip"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.playpen.id

  ingress {
    description = "TLS"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["${local.deployer_ip}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
