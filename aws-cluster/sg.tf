resource "aws_security_group" "mongodb" {
  name        = "AntMedia-MongoDB Security Group"
  description = "Works Internal"
  vpc_id      = data.aws_vpc.default.id

ingress {
    description     = "Allow internal access from AntMedia Servers"
    from_port       = 27017
    to_port         = 27017
    protocol        = "TCP"
    security_groups = [ aws_security_group.server.id ]
  }

egress {
    description = "Allow All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "AntMedia-MongoDB Security Group"
  }

  depends_on = [ aws_security_group.server ]
}

resource "aws_security_group" "server" {
  name        = "AntMedia-Server Security Group"
  description = "Works with Load Balancer and Public Internet"
  vpc_id      = data.aws_vpc.default.id

ingress {
    description = "RTMP"
    from_port   = 1935
    to_port     = 1935
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
    description = "AntMedia HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    description = "WebRTC"
    from_port   = 5000
    to_port     = 65000
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
}

ingress {
    description = "AntMedia Cluster"
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    self        = true
}

 ingress {
   description     = "Allow communication from AntMedia Load Balancer"
   from_port       = 0
   to_port         = 0
   protocol        = "-1"
   security_groups = [ aws_security_group.lb.id ]
 }

egress {
    description = "Allow All Outbound Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "AntMedia-Server Security Group"
  }
}

resource "aws_security_group" "lb" {
  name        = "AntMedia Load Balancer"
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
    description = "AntMedia HTTPS"
    from_port   = 5443
    to_port     = 5443
    protocol    = "TCP"
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
    Name     = "AntMedia Load Balancer" 
  }
}
