resource "aws_api_gateway_rest_api" "api" {
  name = "${local.name_prefix}-api"

  description = "AI AWS Infrastructure Troubleshooter API"
}

resource "aws_api_gateway_resource" "troubleshoot" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  parent_id = aws_api_gateway_rest_api.api.root_resource_id

  path_part = "troubleshoot"
}

resource "aws_api_gateway_method" "post" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  resource_id = aws_api_gateway_resource.troubleshoot.id

  http_method = "POST"

  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  resource_id = aws_api_gateway_resource.troubleshoot.id

  http_method = aws_api_gateway_method.post.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.troubleshooter.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.lambda
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  deployment_id = aws_api_gateway_deployment.deployment.id

  stage_name = var.environment
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id = "AllowAPIGatewayInvoke"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.troubleshooter.function_name

  principal = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}