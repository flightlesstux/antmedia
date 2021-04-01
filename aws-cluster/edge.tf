resource "aws_launch_configuration" "edge" {
  name_prefix                 = "AntMedia-Edge-Group-"
  associate_public_ip_address = true
  image_id                    = data.aws_ami.antmedia.id
  instance_type               = var.edge_ec2_type
  key_name                    = aws_key_pair.ssh.key_name
  user_data                   = data.template_file.init.rendered
  security_groups             = [ aws_security_group.server.id ]

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [ aws_autoscaling_group.origin ]
}

resource "aws_autoscaling_group" "edge" {
  name                 = "AntMedia-Edge-Group"
  desired_capacity     = 2
  max_size             = 10
  min_size             = 2
  health_check_type    = "EC2"
  force_delete         = true
  availability_zones   = var.zones
  launch_configuration = aws_launch_configuration.edge.name
  target_group_arns    = [ aws_lb_target_group.edge.arn ]
  
  tags = (
  [
     {
        "key"                 = "Name"
        "value"               = "AntMedia-Edge"
        "propagate_at_launch" = true
      }
    ])

  timeouts {
    delete = "30m"
  }

  depends_on = [aws_autoscaling_group.origin]
}

resource "aws_autoscaling_policy" "edge" {
  name                      = "AntMedia-Edge-Scale-Policy"
  adjustment_type           = "ChangeInCapacity"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = 120
  autoscaling_group_name    = aws_autoscaling_group.edge.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60.0
  }
}
