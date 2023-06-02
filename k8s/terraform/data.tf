data "aws_ami" "ubuntu" { # Amazon machine image
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "playpen" {
  id = var.aws_vpc_id
}

data "aws_subnet" "public_playpen" {
  id = var.aws_subnet_id
}

data "http" "deployer_ip" {
  url = "https://api64.ipify.org"
}
