# cluster
resource "aws_ecs_cluster" "xtages_cluster" {
  name = "xtages-cluster"
}

resource "aws_launch_configuration" "ecs_xtages_launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = data.aws_ami.latest_ecs.image_id
  instance_type        = var.ecs_instance_type
  key_name             = "xtages-${var.env}"
  iam_instance_profile = aws_iam_instance_profile.ecs_ec2_role.id
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=xtages-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_xtages_asg" {
  name                 = "ecs-xtages-autoscaling"
  vpc_zone_identifier  = var.private_subnet_ids
  launch_configuration = aws_launch_configuration.ecs_xtages_launchconfig.name
  min_size             = 1
  max_size             = 10
  tag {
    key                 = "Terraform"
    value               = true
    propagate_at_launch = true
  }
}

# Scale up alarm

resource "aws_autoscaling_policy" "cpu_asg_policy" {
  name = "CPU-ASG-Policy-Add"
  autoscaling_group_name = aws_autoscaling_group.ecs_xtages_asg.name
  adjustment_type = "ChangeInCapacity"
  scaling_adjustment = "1"
  cooldown = 300
  policy_type = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_above_80p_alarm" {
  alarm_name          = "CPU-above-80p"
  alarm_description   = "CPU above 80%"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ecs_xtages_asg.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_asg_policy.arn]
}

# Scale down alarm

resource "aws_autoscaling_policy" "cpu_asg_policy_scaledown" {
  name                   = "CPU-ASG-Policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.ecs_xtages_asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu_below_5p_alarm" {
  alarm_name          = "CPU-below-5p"
  alarm_description   = "CPU below 5%"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.ecs_xtages_asg.arn
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.cpu_asg_policy_scaledown.arn]
}
