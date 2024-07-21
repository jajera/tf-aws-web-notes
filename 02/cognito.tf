resource "aws_cognito_user_pool" "example" {
  name = "rest-api-gw-${local.suffix}"

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  mfa_configuration = "OFF"

  password_policy {
    minimum_length                   = 16
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }
}

resource "aws_cognito_user_pool_client" "example" {
  name = "rest-api-gw-${local.suffix}"

  user_pool_id = aws_cognito_user_pool.example.id
}

resource "aws_cognito_user" "example" {
  user_pool_id = aws_cognito_user_pool.example.id
  username     = "cognito"
  password     = random_password.cognito.result
  enabled      = true
}
