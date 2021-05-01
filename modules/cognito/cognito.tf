resource "aws_cognito_user_pool" "user_pool" {
  name = "${var.env}-user-pool"

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }
  }

  admin_create_user_config {
    invite_message_template {
      email_message = "Your username is {username} and temporary password is {####}."
      email_subject = "Your temporary password"
      sms_message   = "Your username is {username} and temporary password is {####}."
    }
  }

  auto_verified_attributes = [
    "email"
  ]

  device_configuration {
    challenge_required_on_new_device      = false
    device_only_remembered_on_user_prompt = false
  }

  email_configuration {
    email_sending_account = "DEVELOPER"
    from_email_address    = "Xtages Accounts <no-reply@xtages.com>"
    source_arn            = var.no_reply_at_xtages_dot_com_arn
  }

  email_verification_message = "Your verification code is {####}."
  email_verification_subject = "Your verification code"

  mfa_configuration = "OPTIONAL"

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = false
    name                     = "organization"
    required                 = false
    string_attribute_constraints {
      max_length = "256"
      min_length = "1"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "email"
    required                 = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "name"
    required                 = true
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
    Terraform   = true
    Environment = var.env
  }
}

resource "aws_cognito_user_pool_client" "user_pool_console_web_client" {
  name = "console-web-${var.env}"

  user_pool_id = aws_cognito_user_pool.user_pool.id

  supported_identity_providers = ["COGNITO"]

  allowed_oauth_flows_user_pool_client = false

  access_token_validity  = 1
  id_token_validity      = 1
  refresh_token_validity = 30
  token_validity_units {
    access_token  = "days"
    id_token      = "days"
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

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name               = "${var.env}-identity-pool"
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id               = aws_cognito_user_pool_client.user_pool_console_web_client.id
    provider_name           = aws_cognito_user_pool.user_pool.endpoint
    server_side_token_check = true
  }
}

// TODO(czuniga): This is a workaround because TF doesn't have a way to map principal tags out of the box.
// See https://github.com/hashicorp/terraform-provider-aws/issues/17345
resource "null_resource" "identity_pool_principal_tag_attribute_map" {
  provisioner "local-exec" {
    command = <<EOT
aws cognito-identity set-principal-tag-attribute-map \
--identity-pool-id ${aws_cognito_identity_pool.identity_pool.id} \
--identity-provider-name ${aws_cognito_user_pool.user_pool.endpoint} \
--no-use-defaults \
--principal-tags '{ "client": "aud", "username": "sub", "organization": "custom:organization"}'
EOT
  }
}

resource "aws_iam_role" "authenticated_user_role" {
  name = "cognito_authenticated_user_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "cognito-identity.amazonaws.com"
      },
      "Action": [
        "sts:AssumeRoleWithWebIdentity",
        "sts:TagSession"
      ],
      "Condition": {
        "StringEquals": {
          "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.identity_pool.id}"
        },
        "ForAnyValue:StringLike": {
          "cognito-identity.amazonaws.com:amr": "authenticated"
        }
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "authenticated_user_policy" {
  name = "cognito_authenticated_user_policy"
  role = aws_iam_role.authenticated_user_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "mobileanalytics:PutEvents",
        "cognito-sync:*",
        "cognito-identity:*"
      ],
      "Resource": [
        "*"
      ]
    }
  ]
}
EOF
}

resource "aws_cognito_identity_pool_roles_attachment" "identity_pool" {
  identity_pool_id = aws_cognito_identity_pool.identity_pool.id

  roles = {
    "authenticated" = aws_iam_role.authenticated_user_role.arn
  }
}
