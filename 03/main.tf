locals {
  suffix                          = data.terraform_remote_state.state1.outputs.suffix
  aws_api_gateway_invoke_url      = data.terraform_remote_state.state2.outputs.aws_api_gateway_invoke_url
  aws_api_gateway_notes_url       = data.terraform_remote_state.state2.outputs.aws_api_gateway_notes_url
  aws_cognito_user_pool_arn       = data.terraform_remote_state.state2.outputs.aws_cognito_user_pool_arn
  aws_cognito_user_pool_id        = data.terraform_remote_state.state2.outputs.aws_cognito_user_pool_id
  aws_cognito_user_pool_client_id = data.terraform_remote_state.state2.outputs.aws_cognito_user_pool_client_id
  aws_cognito_test_app_url        = data.terraform_remote_state.state2.outputs.aws_cognito_test_app_url
}

output "aws_cognito_app_url" {
  value = "http://${aws_s3_bucket_website_configuration.web.website_endpoint}"
}

output "aws_api_gateway_invoke_url" {
  value = local.aws_api_gateway_invoke_url
}

output "aws_api_gateway_notes_url" {
  value = local.aws_api_gateway_notes_url
}

output "aws_cognito_user_pool_arn" {
  value = local.aws_cognito_user_pool_arn
}

output "aws_cognito_user_pool_id" {
  value = local.aws_cognito_user_pool_id
}

output "aws_cognito_user_pool_client_id" {
  value = local.aws_cognito_user_pool_client_id
}

output "aws_cognito_test_app_url" {
  value = local.aws_cognito_test_app_url
}
