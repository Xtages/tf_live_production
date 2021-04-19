resource "aws_ses_domain_identity" "xtages_dot_com" {
  domain = "xtages.com"
}

resource "aws_ses_email_identity" "no_reply_at_xtages_dot_com" {
  email = "no-reply@xtages.com"
}

