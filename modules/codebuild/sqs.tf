resource "aws_sqs_queue" "build_updates_deadletter_queue" {
  name                      = "build-updates-deadletter-queue"
  receive_wait_time_seconds = 20
  message_retention_seconds = 1209600 # 14 days

  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_sqs_queue" "build_updates_queue" {
  name                      = "build-updates-queue"
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.build_updates_deadletter_queue.arn
    maxReceiveCount     = 4
  })

  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_sqs_queue_policy" "build_updates_queue_policy" {
  queue_url = aws_sqs_queue.build_updates_queue.id
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
      "Resource": "${aws_sqs_queue.build_updates_queue.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.build_updates_topic.arn}"
        }
      }
    }
  ]
}
EOF
}
