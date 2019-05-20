resource "aws_lambda_function" "lambda" {
  function_name = "${var.function_name}"
  description   = "${var.description}"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.s3_key}"
  role          = "${aws_iam_role.lambda.arn}"
  runtime       = "${var.runtime}"
  handler       = "${var.handler}"
  timeout       = "${var.timeout}"
  memory_size   = "${var.memory_size}"
  tags          = "${var.tags}"
  environment   = ["${slice(list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]

  vpc_config {
    security_group_ids = "${var.security_group_ids}"
    subnet_ids         = "${var.subnet_ids}"
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
  name               = "${var.function_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count = "${(length(var.security_group_ids) > 0 && length(var.subnet_ids) > 0) ? 1 : 0}"
  role  = "${aws_iam_role.lambda.name}"

  // see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
