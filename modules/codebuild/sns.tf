resource "aws_sns_topic" "build_updates_topic" {
  name = "build-updates-topic"
  policy = <<EOF
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "CodeNotification_publish",
      "Effect": "Allow",
      "Principal": {
        "Service": "codestar-notifications.amazonaws.com"
      },
      "Action": "SNS:Publish",
      "Resource": "arn:aws:sns:us-east-1:606626603369:build-updates-topic"
    }
  ]
}
EOF
  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_sns_topic_subscription" "build_updates_topic_sqs_target" {
  topic_arn = aws_sns_topic.build_updates_topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.build_updates_queue.arn
}
