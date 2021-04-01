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

resource "aws_lb" "xtages_console_lb" {
  name = "xtages-console-lb"
  internal = false
  load_balancer_type = "application"
  enable_http2 = true

  security_groups = [aws_security_group.myapp_elb_sg.id]
  subnets = var.public_subnet_ids

  tags = {
    Environment = var.env
  }
}

data "aws_route53_zone" "xtages_zone" {
  name         = "xtages.com"
  private_zone = false
}

data "aws_acm_certificate" "xtages_cert" {
  domain = "xtages.com"
  statuses = ["ISSUED"]
}

resource "aws_route53_record" "console_cname_record" {
  name = "console.xtages.com"
  type = "CNAME"
  zone_id = data.aws_route53_zone.xtages_zone.zone_id
  ttl = 60
  records = [aws_lb.xtages_console_lb.dns_name]
}

resource "aws_lb_listener" "xtages_service_secure" {
  load_balancer_arn = aws_lb.xtages_console_lb.arn
  port = 443
  protocol = "HTTPS"
  certificate_arn = data.aws_acm_certificate.xtages_cert.id
  ssl_policy = "ELBSecurityPolicy-2016-08"

  default_action {
    target_group_arn = aws_lb_target_group.nodejs.id
    type = "forward"
  }
}

resource "aws_lb_listener" "xtages_service" {
  load_balancer_arn = aws_lb.xtages_console_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "nodejs" {
  name = "nodejs"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id
  depends_on = [aws_lb.xtages_console_lb]

  health_check {
    path = "/"
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 30
    interval = 60
    matcher = "200,301,302"
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
    target_group_arn = aws_lb_target_group.nodejs.id
    container_name = "myapp"
    container_port = 3000
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

