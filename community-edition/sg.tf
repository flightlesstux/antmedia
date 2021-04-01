resource "aws_security_group" "antmedia" {
  name        = "AntMedia-Community-Edition Security Group"
  description = "Works with Public Internet"
  vpc_id      = data.aws_vpc.default.id
  
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "AntMedia HTTP"
    from_port   = 5080
    to_port     = 5080
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "AntMedia HTTP"
    from_port   = 5554
    to_port     = 5554
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "AntMedia HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    description = "AntMedia WebRTC"
    from_port   = 5000
    to_port     = 65000
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    description = "Allow All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name     = "AntMedia-Community-Edition Security Group"
  }
}
