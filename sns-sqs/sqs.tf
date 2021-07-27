resource "aws_sqs_queue" "scalein_staging_deadletter_queue" {
  name                      = "scalein-staging-deadletter-queue"
  receive_wait_time_seconds = 20
  message_retention_seconds = 1209600 # 14 days

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "scaling_staging_queue" {
  name                      = "scalein-staging-updates-queue"
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.scalein_staging_deadletter_queue.arn
    maxReceiveCount     = 4
  })

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue_policy" "scaling_updates_queue_policy" {
  queue_url = aws_sqs_queue.scaling_staging_queue.id
  policy    = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.scaling_staging_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.scalein_staging_topic.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "ecs_steady_state_deadletter_queue" {
  name                      = "ecs-steady-state-deadletter-queue"
  receive_wait_time_seconds = 20
  message_retention_seconds = 1209600 # 14 days

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "deployment_updates_deadletter_queue" {
  name                      = "deployment-updates-deadletter-queue"
  receive_wait_time_seconds = 20
  message_retention_seconds = 1209600 # 14 days

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue" "deployment_updates_queue" {
  name                      = "deployment-updates-queue"
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deployment_updates_deadletter_queue.arn
    maxReceiveCount     = 4
  })

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue_policy" "deployment_updates_queue_policy" {
  queue_url = aws_sqs_queue.deployment_updates_queue.id
  policy    = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.deployment_updates_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.deployment_updates_topic.arn}"
        }
      }
    }
  ]
}
EOF
}

resource "aws_sqs_queue" "ecs_steady_state_queue" {
  name                      = "ecs-steady-state-queue"
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.ecs_steady_state_deadletter_queue.arn
    maxReceiveCount     = 4
  })

//  kms_master_key_id = "alias/aws/sqs"
//  kms_data_key_reuse_period_seconds = 300

  tags = local.tags
}

resource "aws_sqs_queue_policy" "ecs_steady_state_queue_policy" {
  queue_url = aws_sqs_queue.ecs_steady_state_queue.id
  policy    = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.ecs_steady_state_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.ecs_steady_state_topic.arn}"
        }
      }
    }
  ]
}
EOF
}
