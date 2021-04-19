resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.env}-user-pool"

  account_recovery_setting {
    recovery_mechanism {
      name = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}."
      email_subject = "Your temporary password"
      sms_message = "Your username is {username} and temporary password is {####}."
    }
  }

  auto_verified_attributes = [
    "email"
  ]

  device_configuration {
    challenge_required_on_new_device = false
    device_only_remembered_on_user_prompt = false
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address = "Xtages Accounts <no-reply@xtages.com>"
    source_arn = var.no_reply_at_xtages_dot_com_arn
  }

  email_verification_message = "Your verification code is {####}."
  email_verification_subject = "Your verification code"

  mfa_configuration = "OPTIONAL"

  password_policy {
    minimum_length = 8
    require_lowercase = true
    require_numbers = true
    require_symbols = true
    require_uppercase = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = false
    name = "organization"
    required = false
    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    name = "email"
    required = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  schema {
    attribute_data_type = "String"
    developer_only_attribute = false
    mutable = true
    name = "name"
    required = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  software_token_mfa_configuration {
    enabled = true
  }

  username_attributes = [
    "email"
  ]

  username_configuration {
    case_sensitive = false
  }

  tags = {
    Terraform = true
    Environment = var.env
  }
}

resource "aws_cognito_user_pool_client" "user_pool_console_web_client" {
  name = "console-web-${var.env}"

  user_pool_id = aws_cognito_user_pool.user_pool.id

  allowed_oauth_flows_user_pool_client = false

  access_token_validity = 1
  id_token_validity = 1
  refresh_token_validity = 30
  token_validity_units {
    access_token = "days"
    id_token = "days"
    refresh_token = "days"
  }

  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  generate_secret = false

  prevent_user_existence_errors = "ENABLED"

  read_attributes = [
    "custom:organization",
    "email",
    "email_verified",
    "name",
  ]

  write_attributes = [
    "custom:organization",
    "email",
    "name",
  ]
}
