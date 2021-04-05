
# ECS outputs

output "xtages_console_alb_arn" {
  value = module.ecs.xtages_console_alb_arn
}

output "xtages_ecs_cluster_id" {
  value = module.ecs.xtages_ecs_cluster_id
}

output "ecs_service_role_arn" {
  value = module.ecs.ecs_service_role_arn
}

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
