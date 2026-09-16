resource "aws_cloudwatch_log_group" "lambda" {
  name = "/aws/lambda/${local.name_prefix}"

  retention_in_days = var.log_retention_days
}

resource "aws_cloudwatch_log_metric_filter" "errors" {
  name = "${local.name_prefix}-errors"

  log_group_name = aws_cloudwatch_log_group.lambda.name

  pattern = "ERROR"

  metric_transformation {
    name = "TroubleshooterErrors"

    namespace = "AIInfrastructureTroubleshooter"

    value = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name = "${local.name_prefix}-lambda-errors"

  namespace = "AIInfrastructureTroubleshooter"

  metric_name = "TroubleshooterErrors"

  statistic = "Sum"

  period = 300

  evaluation_periods = 1

  threshold = 1

  comparison_operator = "GreaterThanOrEqualToThreshold"

  treat_missing_data = "notBreaching"
}