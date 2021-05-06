# ECR repo to store build (CI/CD) Docker images
resource "aws_ecr_repository" "xtages_build_images" {
  name                 = "xtages-build-images"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Terraform = true
    Environment = var.env
  }
}
