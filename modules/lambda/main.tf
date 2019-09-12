resource "aws_lambda_function" "lambda" {
  description = var.description
  dynamic "environment" {
    for_each = var.environment == null ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }
  filename         = var.filename
  function_name    = var.function_name
  handler          = var.handler
  memory_size      = var.memory_size
  publish          = var.publish
  role             = aws_iam_role.lambda.arn
  runtime          = var.runtime
  source_code_hash = filebase64sha256(var.filename)
  tags             = var.tags
  timeout          = var.timeout

  dynamic "vpc_config" {
    for_each = var.vpc_config == null ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = var.function_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count = var.vpc_config == null ? 0 : 1
  role  = aws_iam_role.lambda.name

  // see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
