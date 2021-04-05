data "aws_route53_zone" "xtages_zone" {
  name         = "xtages.com"
  private_zone = false
}

resource "aws_acm_certificate" "xtages_cert" {
  domain_name = "xtages.com"
  validation_method = "DNS"
  subject_alternative_names = ["*.xtages.com"]

  tags = {
    Terraform = true
    Environment = "production"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "xtages_cert_valid" {
  certificate_arn = aws_acm_certificate.xtages_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.xtages_validation_record : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "xtages_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.xtages_cert.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.xtages_zone.zone_id
}

