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
      "kinesis:ListStreams",
      "kinesis:DescribeLimits"
    ]

    resources = [
      // extracting 'arn:${Partition}:kinesis:${Region}:${Account}:stream/' from the kinesis stream ARN
      // see https://docs.aws.amazon.com/IAM/latest/UserGuide/list_amazonkinesis.html#amazonkinesis-resources-for-iam-policies
      length(regexall("arn.*\\/", var.event_source_arn)) > 0 ? "${regex("arn.*\\/", var.event_source_arn)}*" : ""
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
      var.event_source_arn
    ]
  }
}

resource "aws_iam_policy" "stream_policy" {
  count       = var.enable ? 1 : 0
  name        = "${var.function_name}-stream-consumer-${data.aws_region.current.name}"
  description = "Gives permission to list and read a Kinesis stream to ${var.function_name}."
  policy      = data.aws_iam_policy_document.stream_policy_document.json
}

resource "aws_iam_role_policy_attachment" "stream_policy_attachment" {
  count      = var.enable ? 1 : 0
  role       = var.iam_role_name
  policy_arn = aws_iam_policy.stream_policy[count.index].arn
}
