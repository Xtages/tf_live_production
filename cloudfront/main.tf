locals {
  tags                 = {
    Terraform   = true
    Environment = var.env
  }
  // Workaround for https://github.com/hashicorp/terraform-provider-aws/issues/15102
  s3_xtages_cdn_domain = replace(data.terraform_remote_state.xtages_s3.outputs.s3_xtages_cdn_domain, "s3.amazonaws", "s3.${var.aws_region}.amazonaws")
}

data "terraform_remote_state" "xtages_s3" {
  backend = "s3"
  config  = {
    bucket = "xtages-tfstate"
    key    = "tfstate/us-east-1/production/s3"
    region = "us-east-1"
  }
}

resource "aws_cloudfront_origin_access_identity" "xtages_cdn_origin_access_identity" {
  comment = "access-identity-xtages-cdn.s3.us-east-1.amazonaws.com"
}

resource "aws_cloudfront_distribution" "xtages_cdn_distribution" {
  comment         = "xtages-cdn"
  enabled         = true
  is_ipv6_enabled = true
  http_version    = "http2"
  price_class     = "PriceClass_All"
  tags            = local.tags

  default_cache_behavior {
    allowed_methods        = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    cached_methods         = [
      "GET",
      "HEAD",
      "OPTIONS",
    ]
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    compress               = true
    target_origin_id       = local.s3_xtages_cdn_domain
    viewer_protocol_policy = "allow-all"
  }

  origin {
    connection_attempts = 3
    connection_timeout  = 10
    domain_name         = local.s3_xtages_cdn_domain
    origin_id           = local.s3_xtages_cdn_domain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.xtages_cdn_origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1"
  }
}
