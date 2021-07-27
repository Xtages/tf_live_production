locals {
  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_sns_topic" "scalein_staging_topic" {
  name = "scalein-staging-topic"
//  kms_master_key_id = "alias/aws/sns"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:606626603369:scalein-staging-topic"
    }
  ]
}
EOF
  tags = local.tags
}

resource "aws_sns_topic_subscription" "scalein_staging_topic_sqs_target" {
  topic_arn = aws_sns_topic.scalein_staging_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.scaling_staging_queue.arn
}

resource "aws_sns_topic" "ecs_steady_state_topic" {
  name = "ecs-steady-state-topic"
//  kms_master_key_id = "alias/aws/sns"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:606626603369:ecs-steady-state-topic"
    }
  ]
}
EOF
  tags = local.tags
}

resource "aws_sns_topic_subscription" "ecs_steady_state_topic_sqs_target" {
  topic_arn = aws_sns_topic.ecs_steady_state_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.ecs_steady_state_queue.arn
}

resource "aws_sns_topic" "deployment_updates_topic" {
  name = "deployment-updates-topic"
//  kms_master_key_id = "alias/aws/sns"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:606626603369:deployment-updates-topic"
    }
  ]
}
EOF
  tags = local.tags
}

resource "aws_sns_topic_subscription" "deployment_update_topic_sqs_target" {
  topic_arn = aws_sns_topic.deployment_updates_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.deployment_updates_queue.arn
}
