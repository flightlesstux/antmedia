provider "aws" {
  region = var.region
}

resource "aws_key_pair" "ssh" {
  key_name   = "AntMedia"
  public_key = var.ssh_public_key
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "subnets" {
  for_each = data.aws_subnet_ids.subnets.ids
  id       = each.value
}
