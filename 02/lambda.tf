resource "aws_lambda_function" "create" {
  filename         = "${path.module}/../01/external/create_function.zip"
  function_name    = "rest-api-gw-${local.suffix}-create"
  role             = aws_iam_role.create.arn
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../01/external/create_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.example.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.create
  ]
}

resource "aws_lambda_function" "delete" {
  filename         = "${path.module}/../01/external/delete_function.zip"
  function_name    = "rest-api-gw-${local.suffix}-delete"
  role             = aws_iam_role.delete.arn
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../01/external/delete_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.example.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.delete
  ]
}

resource "aws_lambda_function" "dictate" {
  filename         = "${path.module}/../01/external/dictate_function.zip"
  function_name    = "rest-api-gw-${local.suffix}-dictate"
  role             = aws_iam_role.dictate.arn
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../01/external/dictate_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      MP3_BUCKET_NAME = aws_s3_bucket.mp3.bucket
      TABLE_NAME      = aws_dynamodb_table.example.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.dictate
  ]
}

resource "aws_lambda_function" "list" {
  filename         = "${path.module}/../01/external/list_function.zip"
  function_name    = "rest-api-gw-${local.suffix}-list"
  role             = aws_iam_role.list.arn
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../01/external/list_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.example.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.list
  ]
}

resource "aws_lambda_function" "search" {
  filename         = "${path.module}/../01/external/search_function.zip"
  function_name    = "rest-api-gw-${local.suffix}-search"
  role             = aws_iam_role.search.arn
  handler          = "app.lambda_handler"
  source_code_hash = filebase64sha256("${path.module}/../01/external/search_function.zip")
  runtime          = "python3.12"

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.example.name
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.search
  ]
}

resource "aws_lambda_permission" "apigw_invoke_lambda_create" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_lambda_delete" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_lambda_dictate" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.dictate.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_lambda_list" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}

resource "aws_lambda_permission" "apigw_invoke_lambda_search" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.search.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"
}
