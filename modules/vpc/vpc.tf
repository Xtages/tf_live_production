
module "main-vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-${var.env}"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c", "${var.aws_region}d", "${var.aws_region}e", "${var.aws_region}f"]
  private_subnets = ["10.0.0.0/20", "10.0.32.0/20", "10.0.64.0/20", "10.0.96.0/20", "10.0.128.0/20", "10.0.160.0/20"]
  public_subnets  = ["10.0.16.0/21", "10.0.48.0/21", "10.0.80.0/21", "10.0.112.0/21", "10.0.144.0/21", "10.0.176.0/21"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.main-vpc.vpc_id
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.main-vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.main-vpc.public_subnets
}

