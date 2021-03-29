module "main-vpc" {
  source     = "./modules/vpc"
  env        = var.env
  aws_region = var.aws_region
}

module "instances" {
  source         = "./modules/instances"
  env            = var.env
  vpc_id         = module.main-vpc.vpc_id
  public_subnets = module.main-vpc.public_subnets
}

