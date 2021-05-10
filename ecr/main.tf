# ECR repo to store build (CI/CD) Docker images
resource "aws_ecr_repository" "xtages_build_images_node_ci" {
  name                 = "xtages-build-images/node_ci"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_ecr_repository_policy" "codebuild_pull_policy" {
  repository = aws_ecr_repository.xtages_build_images_node_ci.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "CodeBuildAccessPrincipal",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
EOF
}
