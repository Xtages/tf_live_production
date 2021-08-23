data "terraform_remote_state" "xtages_infra" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "xtages_lb_infra" {
  backend = "s3"
  config = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/lbs/lb-tfstate"
    region = "us-east-1"
  }
}

module "ecs" {
  source             = "git::https://github.com/Xtages/tf_ecs.git?ref=v0.1.5"
  cluster_name       = "xtages-customer-production"
  env                = var.env
  aws_region         = var.aws_region
  vpc_id             = data.terraform_remote_state.xtages_infra.outputs.vpc_id
  private_subnet_ids = data.terraform_remote_state.xtages_infra.outputs.private_subnets
  public_subnet_ids  = data.terraform_remote_state.xtages_infra.outputs.public_subnets
  ecs_sg_id          = data.terraform_remote_state.xtages_lb_infra.outputs.customers_ecs_sg_id
  asg_min_size       = 0
  asg_max_size       = 10

  asg_instance_distribution = {
    on_demand_base_capacity                  = 0
    on_demand_percentage_above_base_capacity = 0
    spot_allocation_strategy                 = "lowest-price"
    spot_instance_pools                      = 2
    spot_max_price                           = "0.0464"
  }

  asg_launch_template_override = [
    {
      instance_type     = "m5.large",
      weighted_capacity = "1"
    },
    {
      instance_type     = "t2.large",
      weighted_capacity = "1"
    },
    {
      instance_type     = "t3.large",
      weighted_capacity = "1"
    },
    {
      instance_type     = "t2.medium",
      weighted_capacity = "1"
    },
    {
      instance_type     = "t3.medium",
      weighted_capacity = "1"
    }
  ]
}
