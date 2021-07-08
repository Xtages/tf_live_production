data "terraform_remote_state" "xtages_infra" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production"
    region = "us-east-1"
  }
}

module "ecs" {
  source = "git::https://github.com/Xtages/tf_ecs.git?ref=v0.1.1"
  cluster_name = "xtages-cluster"
  env = var.env
  aws_region = var.aws_region
  vpc_id = data.terraform_remote_state.xtages_infra.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.xtages_infra.outputs.private_subnets
  public_subnet_ids = data.terraform_remote_state.xtages_infra.outputs.public_subnets
}
