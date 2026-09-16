output "api_url" {
  description = "API Gateway troubleshooting endpoint"

  value = "${aws_api_gateway_stage.dev.invoke_url}/troubleshoot"
}

output "lambda_function_name" {
  description = "Lambda function name"

  value = aws_lambda_function.troubleshooter.function_name
}

output "s3_report_bucket" {
  description = "S3 bucket used for troubleshooting reports"

  value = aws_s3_bucket.reports.bucket
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group"

  value = aws_cloudwatch_log_group.lambda.name
}

output "aws_account_id" {
  description = "AWS account ID"

  value = data.aws_caller_identity.current.account_id
}