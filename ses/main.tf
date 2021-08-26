module "ses" {
  source = "git::https://github.com/Xtages/tf_ses.git?ref=v0.1.1"
  domain_identity = "xtages.com"
}
