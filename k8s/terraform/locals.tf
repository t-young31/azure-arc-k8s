locals {
  deployer_ip = data.http.deployer_ip.response_body
  ec2_username = "ec2-user"
}
