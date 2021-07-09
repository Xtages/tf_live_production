output "xtages_console_alb_arn" {
  value = module.lb_console.alb_arn
}

output "xtages_customers_alb_arn" {
  value = module.lb_customers.alb_arn
}

output "xtages_ecs_sg_id" {
  value = module.lb_console.sg_id
}

output "customers_ecs_sg_id" {
  value = module.lb_customers.sg_id
}
