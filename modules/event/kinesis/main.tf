resource "aws_lambda_event_source_mapping" "stream_source" {
  count             = var.enable ? 1 : 0
  batch_size        = var.batch_size
  enabled           = var.event_source_mapping_enabled
  event_source_arn  = var.event_source_arn
  function_name     = var.function_name
  starting_position = var.starting_position
}

resource "aws_iam_role_policy_attachment" "kinesis" {
  count      = var.enable ? 1 : 0
  role       = var.iam_role_name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaKinesisExecutionRole"
}
