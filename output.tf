# VPC outpus

output "vpc_id" {
  value = module.main_vpc.vpc_id
}

output "private_subnets" {
  value = module.main_vpc.private_subnets
}

output "public_subnets" {
  value = module.main_vpc.public_subnets
}

# RDS outputs

output "xtages_postgres_address" {
  value = module.db.db_address
}

