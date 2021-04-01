resource "aws_lb" "antmedia" {
  name                       = "antmedia-loadbalancer"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb.id]
  subnets                    = data.aws_subnet_ids.subnets.ids
  enable_deletion_protection = false

  tags = {
    Name     = "AntMedia Load Balancer"
  }
}

resource "aws_lb_target_group" "origin" {
  name     = "AntMedia-Origin-Group"
  port     = 5080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  stickiness {
      type = "lb_cookie"
  }
}

resource "aws_lb_target_group" "edge" {
  name     = "AntMedia-Edge-Group"
  port     = 5080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  stickiness {
      type = "lb_cookie"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.antmedia.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.origin.arn
      }

      target_group {
        arn = aws_lb_target_group.edge.arn
      }

      stickiness {
        enabled  = true
        duration = 28800
      }
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.antmedia.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.origin.arn
      }

      target_group {
        arn = aws_lb_target_group.edge.arn
      }

      stickiness {
        enabled  = true
        duration = 28800
      }
    }
  }
}

resource "aws_lb_listener" "antmedia-http" {
  load_balancer_arn = aws_lb.antmedia.arn
  port              = "5080"
  protocol          = "HTTP"
  
  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.origin.arn
      }

      target_group {
        arn = aws_lb_target_group.edge.arn
      }

      stickiness {
        enabled  = true
        duration = 28800
      }
    }
  }
}

resource "aws_lb_listener" "antmedia-https" {
  load_balancer_arn = aws_lb.antmedia.arn
  port              = "5443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.ssl

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.origin.arn
      }

      target_group {
        arn = aws_lb_target_group.edge.arn
      }

      stickiness {
        enabled  = true
        duration = 28800
      }
    }
  }
}

output "AntMedia-Loadbalancer-DNS-Name" {
  value = aws_lb.antmedia.dns_name
}
