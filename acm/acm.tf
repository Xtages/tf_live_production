data "aws_route53_zone" "xtages_dev_zone" {
  name         = "xtages.dev"
  private_zone = false
}

resource "aws_acm_certificate" "xtages_dev_cert" {
  domain_name               = "xtages.dev"
  validation_method         = "DNS"
  subject_alternative_names = ["*.xtages.dev"]

  tags = {
    Terraform   = true
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "xtages_dev_cert_valid" {
  certificate_arn         = aws_acm_certificate.xtages_dev_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.xtages_dev_validation_record : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "xtages_dev_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.xtages_dev_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.xtages_dev_zone.zone_id
}

