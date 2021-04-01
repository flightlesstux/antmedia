resource "aws_sns_topic" "antmedia" {
  name = "AntMedia-AutoScaling-Alert"
  delivery_policy = <<EOF
  {
    "http": {
      "defaultHealthyRetryPolicy": {
        "minDelayTarget": 20,
        "maxDelayTarget": 20,
        "numRetries": 3,
        "numMaxDelayRetries": 0,
        "numNoDelayRetries": 0,
        "numMinDelayRetries": 0,
        "backoffFunction": "linear"
      },
      "disableSubscriptionOverrides": false,
      "defaultThrottlePolicy": {
        "maxReceivesPerSecond": 1
      }
    }
  }
  EOF
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.antmedia.arn
  protocol  = "email"
  endpoint  = var.email
}


resource "aws_autoscaling_notification" "antmedia" {
  group_names = [
    aws_autoscaling_group.origin.name,
    aws_autoscaling_group.edge.name,
  ]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.antmedia.arn
}
