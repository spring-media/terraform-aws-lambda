data "aws_region" "current" {
}

resource "aws_lambda_event_source_mapping" "stream_source" {
  count             = var.enable ? 1 : 0
  batch_size        = var.batch_size
  enabled           = var.event_source_mapping_enabled
  event_source_arn  = var.event_source_arn
  function_name     = var.function_name
  starting_position = var.starting_position
}

// see https://github.com/awslabs/serverless-application-model/blob/develop/samtranslator/policy_templates_data/policy_templates.json
data "aws_iam_policy_document" "stream_policy_document" {
  statement {
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetShardIterator",
      "dynamodb:GetRecords"
    ]

    resources = [
      var.event_source_arn
    ]
  }
}

resource "aws_iam_policy" "stream_policy" {
  count       = var.enable ? 1 : 0
  name        = "${var.function_name}-stream-consumer-${data.aws_region.current.name}"
  description = "Provides minimum DynamoDb stream processing permissions for ${var.function_name}."
  policy      = data.aws_iam_policy_document.stream_policy_document.json
}

resource "aws_iam_role_policy_attachment" "stream_policy_attachment" {
  count      = var.enable ? 1 : 0
  role       = var.iam_role_name
  policy_arn = aws_iam_policy.stream_policy[count.index].arn
}

