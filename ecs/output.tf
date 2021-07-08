# ECS outputs

output "xtages_console_alb_arn" {
  value = module.ecs.xtages_console_alb_arn
}

output "xtages_customers_alb_arn" {
  value = module.ecs.xtages_customers_alb_arn
}

output "xtages_ecs_cluster_id" {
  value = module.ecs.xtages_ecs_cluster_id
}

output "ecs_service_role_arn" {
  value = module.ecs.ecs_service_role_arn
}
