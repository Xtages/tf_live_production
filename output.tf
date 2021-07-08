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

output "xtages_postgres_address_dev" {
  value = module.db_dev.db_address
}

# Cognito outputs

output "user_pool_id" {
  value = module.cognito.user_pool_id
}
output "user_pool_console_web_client_id" {
  value = module.cognito.user_pool_console_web_client_id
}

# SES outputs

output "no_reply_at_xtages_dot_com_arn" {
  value = module.ses.no_reply_at_xtages_dot_com_arn
}
