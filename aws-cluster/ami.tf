data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "antmedia" {
  most_recent = true
  owners = ["679593333241"]
  filter {
    name   = "name"
    values = ["AntMedia-AWS-Marketplace-EE-v230_updated-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
