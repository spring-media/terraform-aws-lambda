resource "aws_lambda_permission" "sns" {
  count         = var.enable ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "sns.amazonaws.com"
  statement_id  = "AllowSubscriptionToSNS"
  source_arn    = var.topic_arn
}

resource "aws_sns_topic_subscription" "subscription" {
  count     = var.enable ? 1 : 0
  endpoint  = var.endpoint
  protocol  = "lambda"
  topic_arn = var.topic_arn
}
