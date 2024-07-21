locals {
  suffix = data.terraform_remote_state.state1.outputs.suffix
}

output "aws_api_gateway_invoke_url" {
  value = aws_api_gateway_stage.example.invoke_url
}

output "aws_api_gateway_notes_url" {
  value = "${aws_api_gateway_stage.example.invoke_url}/notes"
}

output "aws_cognito_user_pool_arn" {
  value = aws_cognito_user_pool.example.arn
}

output "aws_cognito_user_pool_id" {
  value = aws_cognito_user_pool.example.id
}

output "aws_cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.example.id
}

output "aws_cognito_test_app_url" {
  value = "http://${aws_s3_bucket_website_configuration.web_testlogin.website_endpoint}"
}

resource "local_file" "config_js" {
  filename = "${path.module}/external/web/src/Config.js"

  content = <<-EOF
    const poolId = '${aws_cognito_user_pool.example.id}'
    const clientId = '${aws_cognito_user_pool_client.example.id}'
    const api = '${aws_api_gateway_stage.example.invoke_url}'

    const Config = {
        UserPoolId: poolId,
        AppClientId: clientId,
        ApiURL: api + '/notes'
    }

    export default Config
  EOF
}
