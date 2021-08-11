locals {
  tags = {
    Terraform   = true
    Environment = var.env
  }
}

resource "aws_s3_bucket" "s3_xtages_buildspecs" {
  bucket = "xtages-buildspecs"
  acl    = "private"
  tags   = local.tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket" "s3_xtages_cdn" {
  bucket = "xtages-cdn"
  acl    = "private"
  tags   = local.tags

  versioning {
    enabled = false
  }
}

resource "aws_s3_bucket_object" "s3_buildspecs_node_ci" {
  bucket         = aws_s3_bucket.s3_xtages_buildspecs.id
  key            = "ci/node/15.13.0-buildspec.yml"
  content_base64 = base64encode(file("${path.root}/buildspec-def/ci/node/15.13.0-buildspec.yml"))
}

resource "aws_s3_bucket_object" "s3_buildspecs_node_cd" {
  bucket         = aws_s3_bucket.s3_xtages_buildspecs.id
  key            = "cd/node/15.13.0-buildspec.yml"
  content_base64 = base64encode(file("${path.root}/buildspec-def/cd/node/15.13.0-buildspec.yml"))
}

resource "aws_s3_bucket" "s3_xtages_tf_remote_customers" {
  bucket = "xtages-tfstate-customers"
  acl    = "private"
  tags   = local.tags

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}
