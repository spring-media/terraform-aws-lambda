data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

resource "aws_lambda_event_source_mapping" "stream_source" {
  count             = var.enable ? 1 : 0
  batch_size        = var.batch_size
  enabled           = var.event_source_mapping_enabled
  event_source_arn  = var.event_source_arn
  function_name     = var.function_name
  starting_position = var.starting_position
}

data "aws_iam_policy_document" "stream_policy_document" {
  statement {
    actions = [
      "kinesis:ListStreams",
      "kinesis:DescribeLimits"
    ]

    resources = [
      "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/*",
    ]
  }

  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator"
    ]

    resources = [
      "arn:aws:kinesis:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:stream/${var.stream_name}",
    ]
  }
}

resource "aws_iam_policy" "stream_policy" {
  count       = var.enable ? 1 : 0
  name        = "${var.function_name}-stream-consumer"
  description = "Gives permission to list and read a Kinesis stream to ${var.function_name}."
  policy      = data.aws_iam_policy_document.stream_policy_document.json
}

resource "aws_iam_role_policy_attachment" "stream_policy_attachment" {
  count      = var.enable ? 1 : 0
  role       = var.iam_role_name
  policy_arn = aws_iam_policy.stream_policy[count.index].arn
}
