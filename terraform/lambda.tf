data "archive_file" "lambda" {
  type        = "zip"
  source_file = "lambda.py"
  output_path = "lambda_function_payload.zip"
}

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "lambda_function_payload.zip"
  function_name = "test-s3-put-lambda-func"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python.3.9"

  environment {
    variables = {
      foo = "bar"
    }
  }
}
