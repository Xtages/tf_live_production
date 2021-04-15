module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "2.34.0"

  identifier = "xtages-${var.env}"

  engine            = "postgres"
  engine_version    = "13.2"
  instance_class    = var.db_instance_class
  storage_encrypted = true
  allocated_storage = var.storage
  max_allocated_storage = 100
  storage_type = "gp2"

  multi_az = false

  name     = var.db_name
  username = var.db_user
  password = data.aws_ssm_parameter.db_password.value
  port     = "5432"

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]

  maintenance_window = "Sat:00:00-Sat:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = var.retention

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "${var.app}RDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    App       = var.app
    Environment = var.env
  }

  # DB subnet group
  subnet_ids = var.private_subnets

  # DB parameter group
  family = "postgres13"
}
