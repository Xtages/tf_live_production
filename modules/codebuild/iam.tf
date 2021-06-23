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
        "Service": "codebuild.amazonaws.com",
        "AWS": "arn:aws:iam::606626603369:user/terraform"
      },
      "Effect": "Allow"
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
        "Service": "codebuild.amazonaws.com",
        "AWS": "arn:aws:iam::606626603369:user/terraform"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "xtages_codebuild_cd_policy" {
  name = "xtages-codebuild-cd-role-policy"
  role = aws_iam_role.xtages_codebuild_cd_role.id
  policy = templatefile("${path.module}/policies/xtages-codebuild-cd-role-policy.json",{})
}

resource "aws_iam_role_policy" "xtages_codebuild_ci_policy" {
  name = "xtages-codebuild-ci-role-policy"
  role = aws_iam_role.xtages_codebuild_ci_role.id
  policy = templatefile("${path.module}/policies/xtages-codebuild-ci-role-policy.json",{})
}
