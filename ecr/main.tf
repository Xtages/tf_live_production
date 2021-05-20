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
    Terraform   = true
    Environment = var.env
  }
}

resource "aws_ecr_repository" "xtages_build_images_node_cd" {
  name                 = "xtages-build-images/node_cd"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "KMS"
  }

  tags = {
    Terraform   = true
    Environment = var.env
  }
}

data "template_file" "codebuild_pull_policy" {
  template = file("${path.root}/policies/codebuild_pull_policy.json")
}

resource "aws_ecr_repository_policy" "codebuild_pull_policy" {
  repository = aws_ecr_repository.xtages_build_images_node_ci.name
  policy     = data.template_file.codebuild_pull_policy.rendered
}

resource "aws_ecr_repository_policy" "codebuild_pull_policy_cd" {
  repository = aws_ecr_repository.xtages_build_images_node_cd.name
  policy     = data.template_file.codebuild_pull_policy.rendered
}
