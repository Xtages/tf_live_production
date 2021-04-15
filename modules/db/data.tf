locals {
  environment = (var.env == "production") ? "prod" : "dev"
}

data "aws_ssm_parameter" "db_password" {
  name = "/config/xtages_${var.app}_${local.environment}/spring.datasource.password"
  with_decryption = true
}
