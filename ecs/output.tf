# ECS outputs
output "xtages_ecs_cluster_id" {
  value = module.ecs.xtages_ecs_cluster_id
}

output "ecs_service_role_arn" {
  value = module.ecs.ecs_service_role_arn
}

output "ecs_capacity_provider_name" {
  value = module.ecs.ecs_capacity_provider_name
}
