resource "aws_iam_role" "xtages_codebuild_ci_role" {
  name               = "xtages-codebuild-ci-role"
  description        = "Role for the CI builders"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "xtages_codebuild_ci_policy" {
  name   = "xtages-codebuild-ci-role-policy"
  role   = aws_iam_role.xtages_codebuild_ci_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:606626603369:log-group:*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/organization": "$${aws:ResourceTag/organization}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "arn:aws:ecr:*:606626603369:repository/xtages-build-images",
        "arn:aws:s3:::xtages-buildspecs/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "xtages_codebuild_cd_role" {
  name               = "xtages-codebuild-cd-role"
  description        = "Role for the CD builders"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "xtages_codebuild_cd_policy" {
  name   = "xtages-codebuild-cd-role-policy"
  role   = aws_iam_role.xtages_codebuild_cd_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:StartImageScan",
        "ecr:PutImageScanningConfiguration",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:ecr:*:606626603369:repository/*",
        "arn:aws:logs:*:606626603369:log-group:*"
      ],
      "Condition": {
        "StringEquals": {
          "aws:ResourceTag/organization": "$${aws:ResourceTag/organization}"
        }
      }
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "arn:aws:ecr:*:606626603369:repository/xtages-build-images",
        "arn:aws:s3:::xtages-buildspecs/*"
      ]
    }
  ]
}
EOF
}
