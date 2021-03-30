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
  security_groups      = [aws_security_group.ecs-sg.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=xtages-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-xtages-autoscaling" {
  name                 = "ecs-xtages-autoscaling"
  vpc_zone_identifier  = var.private_subnet_ids
  launch_configuration = aws_launch_configuration.ecs_xtages_launchconfig.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = "Name"
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}

