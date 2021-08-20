module "main_vpc" {
  source     = "git::https://github.com/Xtages/tf_vpc.git?ref=v0.1.0"
  env        = var.env
  aws_region = var.aws_region
}

module "jumphost" {
  source         = "git::https://github.com/Xtages/tf_jumphost.git?ref=v0.1.0"
  env            = var.env
  vpc_id         = module.main_vpc.vpc_id
  public_subnets = module.main_vpc.public_subnets
}

module "db" {
  source = "./modules/db"
  env = var.env
  db_name = "xtages_console"
  db_user = "xtages_console"
  vpc_id = module.main_vpc.vpc_id
  private_subnets = module.main_vpc.private_subnets
  app = "console"
  storage = 20
  retention = 7
  db_instance_class = "db.t3.micro"
}

module "db_dev" {
  source = "./modules/db"
  env = "development"
  db_name = "xtages_console"
  db_user = "xtages_console"
  vpc_id = module.main_vpc.vpc_id
  private_subnets = module.main_vpc.private_subnets
  app = "console"
  storage = 20
  retention = 0
  db_instance_class = "db.t3.micro"
}

module "cognito" {
  source = "./modules/cognito"
  no_reply_at_xtages_dot_com_arn = module.ses.no_reply_at_xtages_dot_com_arn
  env = var.env
}

module "ses" {
  source = "./modules/ses"
}

module "codebuild" {
  source     = "git::https://github.com/Xtages/tf_codebuild.git?ref=v0.1.3"
  env        = var.env
  account_id = var.account_id
}
