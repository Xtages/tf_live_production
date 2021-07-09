data "terraform_remote_state" "xtages_infra" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production"
    region = "us-east-1"
  }
}

module "lb_console" {
  source            = "git::https://github.com/Xtages/tf_lbs.git?ref=v0.1.1"
  alb_name          = "console-lb-${var.env}"
  env               = var.env
  aws_region        = var.aws_region
  vpc_id            = data.terraform_remote_state.xtages_infra.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.xtages_infra.outputs.public_subnets
  app               = "Console"
  organization      = "Xtages"
}

module "lb_customers" {
  source            = "git::https://github.com/Xtages/tf_lbs.git?ref=v0.1.1"
  alb_name          = "customers-lb-${var.env}"
  env               = var.env
  aws_region        = var.aws_region
  vpc_id            = data.terraform_remote_state.xtages_infra.outputs.vpc_id
  public_subnet_ids = data.terraform_remote_state.xtages_infra.outputs.public_subnets
  app               = "Customer Apps"
  organization      = "Xtages"
}
