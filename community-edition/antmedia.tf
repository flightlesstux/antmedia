resource "aws_instance" "antmedia" {
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  ami                         = data.aws_ami.ubuntu.id
  key_name                    = aws_key_pair.ssh.key_name
  user_data                   = file("${path.cwd}/user-data.sh")
  vpc_security_group_ids      = [ aws_security_group.antmedia.id ]
  
  tags = {
  Name = "AntMedia-Community-Edition"
  }    

  ebs_block_device {
  device_name           = "/dev/sda1"
  delete_on_termination = true
  volume_size           = 8
  
  tags = {
  Name = "AntMedia-Community-Edition"
    }
  }
}

data "aws_instance" "antmedia" {
  filter {
    name   = "tag:Name"
    values = [ "AntMedia-Community-Edition"]
  }

  depends_on = [ aws_instance.antmedia ]
}

output "AntMedia-Community-Edition-Server-IP" {
   value = data.aws_instance.antmedia.public_ip
}
