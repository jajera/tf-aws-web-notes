locals {
  apigw_stage = "Prod"
  apigw_title = "PollyNotesAPI"
}

resource "aws_api_gateway_rest_api" "example" {
  name = "rest-api-gw-${local.suffix}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "notes" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "notes"
}

resource "aws_api_gateway_method" "notes_options" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "notes_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.notes_options]
}

resource "aws_api_gateway_integration" "notes_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [
    aws_api_gateway_method.notes_options,
    aws_api_gateway_method_response.notes_options
  ]
}

resource "aws_api_gateway_integration_response" "notes_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_options.http_method
  status_code = aws_api_gateway_method_response.notes_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.notes_options,
    aws_api_gateway_method_response.notes_options
  ]
}

resource "aws_api_gateway_method" "notes_get" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.example.id
}

resource "aws_api_gateway_integration" "notes_get" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.notes.id
  http_method             = aws_api_gateway_method.notes_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.list.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
  "UserId": "$context.authorizer.claims['cognito:username']"
}
EOF
  }
}

resource "aws_api_gateway_method_response" "notes_get" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "notes_get" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_get.http_method
  status_code = aws_api_gateway_method_response.notes_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
[
    #foreach($elem in $inputRoot)
    {
        "NoteId" : "$elem.NoteId",
        "Note" : "$elem.Note"
    }
    #if($foreach.hasNext),#end
    #end
]
EOF
  }

  depends_on = [
    aws_api_gateway_integration.notes_get
  ]
}

resource "aws_api_gateway_integration" "notes_post" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.notes.id
  http_method             = aws_api_gateway_method.notes_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.create.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
    "UserId": "$context.authorizer.claims['cognito:username']",
    "NoteId": $input.json('$.NoteId'),
    "Note": $input.json('$.Note')
}
EOF
  }
}

resource "aws_api_gateway_method_response" "notes_post" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_method" "notes_post" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.example.id

  request_models = {
    "application/json" = aws_api_gateway_model.example.name
  }

  request_validator_id = aws_api_gateway_request_validator.example.id
}

resource "aws_api_gateway_integration_response" "notes_post" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes.id
  http_method = aws_api_gateway_method.notes_post.http_method
  status_code = aws_api_gateway_method_response.notes_post.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_integration.notes_post
  ]
}

resource "aws_api_gateway_resource" "notes_id" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_resource.notes.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "notes_id_options" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.id" = false
  }
}

resource "aws_api_gateway_method_response" "notes_id_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.notes_id_options]
}

resource "aws_api_gateway_integration" "notes_id_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [
    aws_api_gateway_method.notes_id_options,
    aws_api_gateway_method_response.notes_id_options
  ]
}

resource "aws_api_gateway_integration_response" "notes_id_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_options.http_method
  status_code = aws_api_gateway_method_response.notes_id_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.notes_id_options,
    aws_api_gateway_method_response.notes_id_options
  ]
}

resource "aws_api_gateway_method" "notes_id_delete" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes_id.id
  http_method   = "DELETE"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.example.id

  request_parameters = {
    "method.request.path.id" = false
  }
}

resource "aws_api_gateway_integration" "notes_id_delete" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.notes_id.id
  http_method             = aws_api_gateway_method.notes_id_delete.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.delete.invoke_arn

  request_templates = {
    "application/json" = <<EOF
  {
      "UserId": "$context.authorizer.claims['cognito:username']",
      "NoteId": "$input.params('id')"
  }
  EOF
  }
}

resource "aws_api_gateway_method_response" "notes_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_delete.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "notes_id_delete" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_delete.http_method
  status_code = aws_api_gateway_method_response.notes_id_delete.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.notes_id_delete
  ]
}

resource "aws_api_gateway_method" "notes_id_post" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes_id.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.example.id

  request_parameters = {
    "method.request.path.id" = false
  }
}

resource "aws_api_gateway_integration" "notes_id_post" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.notes_id.id
  http_method             = aws_api_gateway_method.notes_id_post.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.dictate.invoke_arn

  request_templates = {
    "application/json" = <<EOF
  {
      "VoiceId": $input.json('$.VoiceId'),
      "UserId": "$context.authorizer.claims['cognito:username']",
      "NoteId": "$input.params('id')"
  }
  EOF
  }
}

resource "aws_api_gateway_method_response" "notes_id_post" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_post.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "notes_id_post" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_id.id
  http_method = aws_api_gateway_method.notes_id_post.http_method
  status_code = aws_api_gateway_method_response.notes_id_post.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.notes_id_post
  ]
}

resource "aws_api_gateway_resource" "notes_search" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  parent_id   = aws_api_gateway_resource.notes.id
  path_part   = "search"
}

resource "aws_api_gateway_method" "notes_search_options" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes_search.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "notes_search_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_search.id
  http_method = aws_api_gateway_method.notes_search_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [
    aws_api_gateway_method.notes_id_options
  ]
}

resource "aws_api_gateway_integration" "notes_search_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_search.id
  http_method = aws_api_gateway_method.notes_id_options.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }

  depends_on = [
    aws_api_gateway_method.notes_search_options,
    aws_api_gateway_method_response.notes_search_options
  ]
}

resource "aws_api_gateway_integration_response" "notes_search_options" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_search.id
  http_method = aws_api_gateway_method.notes_search_options.http_method
  status_code = aws_api_gateway_method_response.notes_search_options.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_integration.notes_search_options,
    aws_api_gateway_method_response.notes_search_options
  ]
}

resource "aws_api_gateway_method" "notes_search_get" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  resource_id   = aws_api_gateway_resource.notes_search.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.example.id

  request_parameters = {
    "method.request.path.id" = false
  }
}

resource "aws_api_gateway_integration" "notes_search_get" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.notes_search.id
  http_method             = aws_api_gateway_method.notes_search_get.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.search.invoke_arn

  request_templates = {
    "application/json" = <<EOF
{
    "UserId": "$context.authorizer.claims['cognito:username']",
    "NoteId": "$input.params('text')"
}
  EOF
  }
}

resource "aws_api_gateway_method_response" "notes_search_get" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_search.id
  http_method = aws_api_gateway_method.notes_search_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

resource "aws_api_gateway_integration_response" "notes_search_get" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  resource_id = aws_api_gateway_resource.notes_search.id
  http_method = aws_api_gateway_method.notes_search_get.http_method
  status_code = aws_api_gateway_method_response.notes_search_get.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
[
  #foreach($elem in $inputRoot)
  {
    "NoteId" : "$elem.NoteId",
    "Note" : "$elem.Note"
  }
  #if($foreach.hasNext),#end
  #end
]
EOF
  }

  depends_on = [
    aws_api_gateway_integration.notes_search_get
  ]
}

resource "aws_api_gateway_model" "example" {
  name         = "NoteModel"
  description  = "A schema model for notes"
  rest_api_id  = aws_api_gateway_rest_api.example.id
  content_type = "application/json"
  schema       = <<EOF
{
  "$schema": "https://json-schema.org/draft-04/schema#",
  "title": "Note",
  "type": "object",
  "properties": {
    "NoteId": {
      "type": "integer"
    },
    "Note": {
      "type": "string"
    }
  },
  "required": [
    "NoteId",
    "Note"
  ]
}
  EOF
}

resource "aws_api_gateway_gateway_response" "default_4xx" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  response_type = "DEFAULT_4XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }
}

resource "aws_api_gateway_gateway_response" "default_5xx" {
  rest_api_id   = aws_api_gateway_rest_api.example.id
  response_type = "DEFAULT_5XX"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }
}

resource "aws_api_gateway_account" "example" {
  cloudwatch_role_arn = aws_iam_role.apigw_lambda.arn
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.example.body))
    # redeployment = "${timestamp()}"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_account.example,
    aws_api_gateway_integration.notes_get,
    aws_api_gateway_integration.notes_options,
    aws_api_gateway_integration.notes_post,
    aws_api_gateway_method_response.notes_get,
    aws_api_gateway_method_response.notes_options,
    aws_api_gateway_method_response.notes_post,
    aws_api_gateway_method.notes_get,
    aws_api_gateway_method.notes_options,
    aws_api_gateway_method.notes_post
  ]
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "Prod"

  access_log_settings {
    destination_arn = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:/aws/apigateway/rest-api-gw-${local.suffix}/prod"
    format = jsonencode({
      requestId      = "$context.requestId",
      ip             = "$context.identity.sourceIp",
      caller         = "$context.identity.caller",
      user           = "$context.identity.user",
      requestTime    = "$context.requestTime",
      httpMethod     = "$context.httpMethod",
      resourcePath   = "$context.resourcePath",
      status         = "$context.status",
      protocol       = "$context.protocol",
      responseLength = "$context.responseLength"
    })
  }

  depends_on = [
    aws_cloudwatch_log_group.rest_api_gw
  ]
}

resource "aws_api_gateway_method_settings" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id
  stage_name  = aws_api_gateway_stage.example.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_authorizer" "example" {
  name                   = "rest-api-gw-${local.suffix}"
  rest_api_id            = aws_api_gateway_rest_api.example.id
  authorizer_uri         = "arn:aws:apigateway:${data.aws_region.current.name}:cognito-idp:authorizer/${aws_cognito_user_pool.example.id}"
  authorizer_credentials = aws_iam_role.apigw_exec.arn

  type            = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"

  provider_arns = [
    aws_cognito_user_pool.example.arn
  ]
}

resource "aws_api_gateway_request_validator" "example" {
  rest_api_id                 = aws_api_gateway_rest_api.example.id
  name                        = "rest-api-gw-${local.suffix}"
  validate_request_body       = true
  validate_request_parameters = true
}
