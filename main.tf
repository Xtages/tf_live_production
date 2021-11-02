module "main_vpc" {
  source     = "git::https://github.com/Xtages/tf_vpc.git?ref=v0.1.0"
  env        = var.env
  aws_region = var.aws_region
}

module "jumphost" {
  source         = "git::https://github.com/Xtages/tf_jumphost.git?ref=v0.1.1"
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
  db_instance_class = "db.t4g.medium"
}

module "codebuild" {
  source     = "git::https://github.com/Xtages/tf_codebuild.git?ref=v0.1.7"
  env        = var.env
  account_id = var.account_id
  subnets    = module.main_vpc.private_subnets
}
