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
