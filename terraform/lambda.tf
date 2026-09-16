data "archive_file" "lambda_zip" {
  type = "zip"

  source_file = "${path.module}/../lambda/troubleshooter.py"

  output_path = "${path.module}/troubleshooter.zip"
}

resource "aws_lambda_function" "troubleshooter" {
  function_name = local.name_prefix

  filename = data.archive_file.lambda_zip.output_path

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role = aws_iam_role.lambda_role.arn

  handler = "troubleshooter.lambda_handler"

  runtime = "python3.12"

  timeout = 60

  memory_size = 512

  environment {
    variables = {
      BEDROCK_MODEL_ID = var.bedrock_model_id
      REPORT_BUCKET    = aws_s3_bucket.reports.bucket
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda
  ]
}