resource "aws_lambda_event_source_mapping" "stream_source" {
  count             = "${var.enable}"
  event_source_arn  = "${var.stream_event_source_arn}"
  function_name     = "${var.function_name}"
  starting_position = "${var.stream_starting_position}"
}

data "aws_iam_policy_document" "stream_policy_document" {
  statement {
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
  count       = "${var.enable}"
  name        = "${var.function_name}-stream-consumer"
  description = "Provides minimum DynamoDb stream processing permissions for ${var.function_name}."
  policy      = "${data.aws_iam_policy_document.stream_policy_document.json}"
}

resource "aws_iam_role_policy_attachment" "stream_policy_attachment" {
  count      = "${var.enable}"
  role       = "${var.iam_role_name}"
  policy_arn = "${aws_iam_policy.stream_policy.arn}"
}
