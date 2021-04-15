module "main_vpc" {
  source     = "./modules/vpc"
  env        = var.env
  aws_region = var.aws_region
}

module "jumphost" {
  source         = "./modules/jumphost"
  env            = var.env
  vpc_id         = module.main_vpc.vpc_id
  public_subnets = module.main_vpc.public_subnets
}

module "ecs" {
  source = "./modules/ecs"
  env = var.env
  aws_region = var.aws_region
  vpc_id = module.main_vpc.vpc_id
  private_subnet_ids = module.main_vpc.private_subnets
  public_subnet_ids = module.main_vpc.public_subnets
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
  db_instance_class = "db.t3.micro"
}
