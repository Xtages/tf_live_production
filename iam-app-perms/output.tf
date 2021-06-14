output "apps_iam_role_arn" {
  value = aws_iam_role.ecs_app_task_role.arn
}
