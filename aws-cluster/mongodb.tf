data "aws_instance" "mongodb" {
  filter {
    name   = "tag:Name"
    values = [ "AntMedia-MongoDB" ]
  }
  depends_on = [ aws_instance.mongodb ]
}

resource "aws_instance" "mongodb" {
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  user_data                   = file("${path.cwd}/user-data/mongodb.sh")
  vpc_security_group_ids      = [ aws_security_group.mongodb.id ]
  
  tags = {
  Name = "AntMedia-MongoDB"
  }    

  ebs_block_device {
  device_name           = "/dev/sda1"
  delete_on_termination = true
  volume_size           = 8
  
  tags = {
  Name = "AntMedia-MongoDB"
    }
  }
}
