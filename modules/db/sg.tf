resource "aws_security_group" "postgres_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.app}-${local.environment}-db-sg"
  description = "DB security group for ${var.app}"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    App = var.app
    Environment = var.env
  }
}
