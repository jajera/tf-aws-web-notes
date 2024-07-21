
resource "aws_cloudwatch_log_group" "create" {
  name              = "/aws/lambda/rest-api-gw-${local.suffix}-create"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "delete" {
  name              = "/aws/lambda/rest-api-gw-${local.suffix}-delete"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "dictate" {
  name              = "/aws/lambda/rest-api-gw-${local.suffix}-dictate"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "list" {
  name              = "/aws/lambda/rest-api-gw-${local.suffix}-list"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "search" {
  name              = "/aws/lambda/rest-api-gw-${local.suffix}-search"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_cloudwatch_log_group" "rest_api_gw" {
  name              = "/aws/apigateway/rest-api-gw-${local.suffix}/prod"
  retention_in_days = 1

  lifecycle {
    prevent_destroy = false
  }
}
