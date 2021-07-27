output "sns_scaling_staging" {
  value = aws_sns_topic.scalein_staging_topic.arn
}

output "sns_deployment_completed" {
  value = aws_sns_topic.deployment_updates_topic.arn
}

output "sns_ecs_steady_state" {
  value = aws_sns_topic.ecs_steady_state_topic.arn
}
