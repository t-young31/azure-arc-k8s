
resource "aws_vpc" "rancher" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.aws_prefix}-rancher-vpc"
  }
}

resource "aws_internet_gateway" "rancher" {
  vpc_id = aws_vpc.rancher.id

  tags = {
    Name = "${var.aws_prefix}-rancher-gateway"
  }

  depends_on = [
    aws_subnet.rancher
  ]
}

resource "aws_subnet" "rancher" {
  vpc_id = aws_vpc.rancher.id

  cidr_block              = "10.1.0.0/24"
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.aws_prefix}-rancher-subnet"
  }
}

resource "aws_route_table" "rancher_route_table" {
  vpc_id = aws_vpc.rancher.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rancher.id
  }

  tags = {
    Name = "${var.aws_prefix}-rancher-route-table"
  }
}

resource "aws_route_table_association" "rancher_route_table_association" {
  subnet_id      = aws_subnet.rancher.id
  route_table_id = aws_route_table.rancher_route_table.id
}

resource "aws_security_group" "allow_all_tls_from_deployer_ip" {
  name        = "${var.aws_prefix}-allow-all-from-deployer-ip"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.rancher.id

  ingress {
    description = "TLS"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    #cidr_blocks = ["10.0.0.0/8", "${local.deployer_ip}/32"]  # doesn't work..
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
