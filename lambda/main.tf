resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}"
  description   = "${var.description}"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.s3_key}"
  role          = "${aws_iam_role.lambda.arn}"
  runtime       = "${var.runtime}"
  handler       = "${var.handler != "" ? var.handler : var.name}"
  timeout       = "${var.timeout}"
  memory_size   = "${var.memory_size}"
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
  name = "${var.function_name}-role"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

data "aws_iam_policy_document" "cloudwatch_logs" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "${var.function_name}-cloudwatch-logs"
  description = "Provides minimum CloudWatch Logs permissions for ${var.function_name}."
  policy      = "${data.aws_iam_policy_document.cloudwatch_logs.json}"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_policy_attachment" {
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.cloudwatch_logs_policy.arn}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${aws_lambda_function.lambda.function_name}"
  retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_lambda_permission" "cloudwatch" {
  count         = "${var.schedule_expression != "" ? 1 : 0}"
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.lambda.arn}"
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = "${var.schedule_expression != "" ? 1 : 0}"
  name                = "${var.function_name}"
  schedule_expression = "${var.schedule_expression}"
}

resource "aws_cloudwatch_event_target" "lambda" {
  count     = "${var.schedule_expression != "" ? 1 : 0}"
  target_id = "${var.function_name}"
  rule      = "${aws_cloudwatch_event_rule.lambda.name}"
  arn       = "${aws_lambda_function.lambda.arn}"
}

resource "aws_lambda_event_source_mapping" "stream_source" {
  count             = "${var.stream_enabled}"
  event_source_arn  = "${var.stream_event_source_arn}"
  function_name     = "${aws_lambda_function.lambda.function_name}"
  starting_position = "${var.stream_starting_position}"
}

data "aws_iam_policy_document" "stream_policy_document" {
  statement {
    // TODO: support kinesis
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetShardIterator",
      "dynamodb:GetRecords",
      "dynamodb:ListStreams",
    ]

    // TODO: restrict on specific table/region/account?
    resources = [
      "arn:aws:dynamodb:*:*:*",
    ]
  }
}

resource "aws_iam_policy" "stream_policy" {
  count       = "${var.stream_enabled}"
  name        = "${var.function_name}-stream-consumer"
  description = "Provides minimum DynamoDb stream processing permissions for ${var.function_name}."
  policy      = "${data.aws_iam_policy_document.stream_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "stream_policy_attachment" {
  count      = "${var.stream_enabled}"
  role       = "${aws_iam_role.lambda.name}"
  policy_arn = "${aws_iam_policy.stream_policy.arn}"
}
