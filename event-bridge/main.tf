locals {
  staging_cluster_name = split("/", data.terraform_remote_state.ecs_customer_staging.outputs.xtages_ecs_cluster_id)[1]
}

# Event name can be seen here
# https://docs.aws.amazon.com/AmazonECS/latest/userguide/ecs_cwe_events.html

resource "aws_cloudwatch_event_rule" "ecs_scalein_staging" {
  name        = "ecs-scalein-staging"
  description = "Notifies Console when a change in the desired count happened"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "userIdentity": {
      "sessionContext": {
        "sessionIssuer": {
          "userName": [
            "AWSServiceRoleForApplicationAutoScaling_ECSService"
          ]
        }
      }
    },
    "eventSource": [
      "ecs.amazonaws.com"
    ],
    "eventName": [
      "UpdateService"
    ],
    "requestParameters": {
      "cluster": [
        "${local.staging_cluster_name}"
      ],
      "desiredCount": [0]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_scale_in_staging" {
  rule      = aws_cloudwatch_event_rule.ecs_scalein_staging.name
  arn       = data.terraform_remote_state.xtages_sns_sqs.outputs.sns_scaling_staging
}

# notification for deployment completed\
resource "aws_cloudwatch_event_rule" "ecs_deployment_completed" {
  name        = "ecs-deployment-completed"
  description = "Notifies Console when a deployment was completed successfully"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Deployment State Change"
  ],
  "detail": {
    "eventName": [
      "SERVICE_DEPLOYMENT_COMPLETED"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_deploy_completed" {
  rule      = aws_cloudwatch_event_rule.ecs_deployment_completed.name
  arn       = data.terraform_remote_state.xtages_sns_sqs.outputs.sns_deployment_completed
}
