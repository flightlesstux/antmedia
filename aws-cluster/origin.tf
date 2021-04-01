data "template_file" "init" {
  template = file("${path.cwd}/user-data/antmedia.sh")
  vars = {
    mongodb_private_ip = data.aws_instance.mongodb.private_ip
  }
}

resource "aws_launch_configuration" "origin" {
  name_prefix                 = "AntMedia-Origin-Group-"
  associate_public_ip_address = true
  image_id                    = data.aws_ami.antmedia.id
  key_name                    = aws_key_pair.ssh.key_name
  instance_type               = var.origin_ec2_type
  user_data                   = data.template_file.init.rendered
  security_groups             = [ aws_security_group.server.id ]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_instance.mongodb ]
}

resource "aws_autoscaling_group" "origin" {
  name                 = "AntMedia-Origin-Group"
  desired_capacity     = 1
  max_size             = 10
  min_size             = 1
  health_check_type    = "EC2"
  force_delete         = true
  availability_zones   = var.zones
  target_group_arns    = [ aws_lb_target_group.origin.arn ]
  launch_configuration = aws_launch_configuration.origin.name
  
  tags = (
  [
     {
        "key"                 = "Name"
        "value"               = "AntMedia-Origin"
        "propagate_at_launch" = true
      }
    ])

  timeouts {
    delete = "30m"
  }

  depends_on = [ aws_lb.antmedia]
}

resource "aws_autoscaling_policy" "origin" {
  name                      = "AntMedia-Origin-Scale-Policy"
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 120
  autoscaling_group_name    = aws_autoscaling_group.origin.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}

data "aws_instance" "origin" {
  filter {
    name   = "tag:Name"
    values = [ "AntMedia-Origin"]
  }

  depends_on = [ aws_autoscaling_group.origin ]
}

output "AntMedia-Origin-Server-IP" {
   value = data.aws_instance.origin.public_ip
}

output "AntMedia-Origin-Server-Instance-ID" {
   value = data.aws_instance.origin.id
}
