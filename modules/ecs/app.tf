# app

data "template_file" "myapp-task-definition-template" {
  template = file("${path.module}/templates/app.json.tpl")
//  vars = {
//    REPOSITORY_URL = replace("606626603369.dkr.ecr.us-east-1.amazonaws.com/myapp", "https://", "")
//  }
}

resource "aws_ecs_task_definition" "myapp_task_definition" {
  family                = "myapp"
  container_definitions = data.template_file.myapp-task-definition-template.rendered
}

resource "aws_elb" "myapp_elb" {
  name = "myapp-elb"

  listener {
    instance_port     = 3000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:3000/"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = var.public_subnet_ids
  security_groups = [aws_security_group.myapp_elb_sg.id]

  tags = {
    Name = "myapp-elb"
  }
}

resource "aws_ecs_service" "myapp-service" {
  name            = "myapp"
  cluster         = aws_ecs_cluster.xtages_cluster.id
  task_definition = aws_ecs_task_definition.myapp_task_definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs_service_role.arn
  depends_on      = [aws_iam_policy_attachment.ecs_service_attach1]

  load_balancer {
    elb_name       = aws_elb.myapp_elb.name
    container_name = "myapp"
    container_port = 3000
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

