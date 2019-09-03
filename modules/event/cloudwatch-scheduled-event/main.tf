resource "aws_lambda_permission" "cloudwatch" {
  count         = var.enable
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[0].arn
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = var.enable
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.enable
  rule  = aws_cloudwatch_event_rule.lambda[0].name
  arn   = var.lambda_function_arn
}

