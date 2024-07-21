resource "aws_secretsmanager_secret" "cognito" {
  name                    = "rest-api-gw-${local.suffix}"
  recovery_window_in_days = 0
}

resource "random_password" "cognito" {
  length           = 16
  special          = true
  override_special = "_!#%&*()-<=>?[]^_{|}~"
}

resource "aws_secretsmanager_secret_version" "cognito" {
  secret_id     = aws_secretsmanager_secret.cognito.id
  secret_string = "{\"cognito\": \"${random_password.cognito.result}\"}"
}
