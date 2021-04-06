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
