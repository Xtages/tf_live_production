locals {
  staging_cluster_name = split("/", data.terraform_remote_state.ecs_customer_staging.outputs.xtages_ecs_cluster_id)[1]
  production_cluster_name = split("/", data.terraform_remote_state.ecs_customer_production.outputs.xtages_ecs_cluster_id)[1]
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

# notification for steady state
resource "aws_cloudwatch_event_rule" "ecs_steady_state" {
  name        = "ecs-steady-state"
  description = "Notifies Console an ECS service has reached a steady state"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "ECS Service Action"
  ],
  "detail": {
    "eventName": [
      "SERVICE_STEADY_STATE"
    ],
    "clusterArn": [
      "${data.terraform_remote_state.ecs_customer_staging.outputs.xtages_ecs_cluster_id}",
      "${data.terraform_remote_state.ecs_customer_production.outputs.xtages_ecs_cluster_id}"
    ]
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_ecs_steady_state" {
  rule      = aws_cloudwatch_event_rule.ecs_steady_state.name
  arn       = data.terraform_remote_state.xtages_sns_sqs.outputs.sns_ecs_steady_state
}

resource "aws_cloudwatch_event_rule" "ecs_cloudtrail_redeploy" {
  name        = "ecs-redeployment-started"
  description = "Notifies to Console when a redeployment is started"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ecs.amazonaws.com"
    ],
    "eventName": [
      "UpdateService"
    ],
    "requestParameters": {
      "cluster": [
        "${data.terraform_remote_state.ecs_customer_staging.outputs.xtages_ecs_cluster_id}",
        "${data.terraform_remote_state.ecs_customer_production.outputs.xtages_ecs_cluster_id}"
      ],
      "taskDefinition": [{
        "exists": true
      }]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_redeploy_started" {
  rule      = aws_cloudwatch_event_rule.ecs_cloudtrail_redeploy.name
  arn       = data.terraform_remote_state.xtages_sns_sqs.outputs.sns_deployment_completed
}

resource "aws_cloudwatch_event_rule" "ecs_cloudtrail_deploy" {
  name        = "ecs-deploy-started"
  description = "Notifies to Console when a 1st deployment is started"

  event_pattern = <<EOF
{
  "source": [
    "aws.ecs"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ecs.amazonaws.com"
    ],
    "eventName": [
      "CreateService"
    ],
    "requestParameters": {
      "cluster": [
        "${data.terraform_remote_state.ecs_customer_staging.outputs.xtages_ecs_cluster_id}",
        "${data.terraform_remote_state.ecs_customer_production.outputs.xtages_ecs_cluster_id}"
      ],
      "desiredCount": [1]
    }
  }
}
EOF
}

resource "aws_cloudwatch_event_target" "sns_deploy_started" {
  rule      = aws_cloudwatch_event_rule.ecs_cloudtrail_deploy.name
  arn       = data.terraform_remote_state.xtages_sns_sqs.outputs.sns_deployment_completed
}
