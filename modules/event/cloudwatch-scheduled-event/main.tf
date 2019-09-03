resource "aws_lambda_permission" "cloudwatch" {
  count         = var.enable ? 1 : 0
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda[count.index].arn
}

resource "aws_cloudwatch_event_rule" "lambda" {
  count               = var.enable ? 1 : 0
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "lambda" {
  count = var.enable ? 1 : 0
  rule  = aws_cloudwatch_event_rule.lambda[count.index].name
  arn   = var.lambda_function_arn
}

