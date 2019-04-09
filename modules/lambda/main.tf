resource "aws_lambda_function" "lambda" {function_name = "${var.function_name}"
  description   = "${var.description}"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.s3_key}"
  role          = "${aws_iam_role.lambda.arn}"
  runtime       = "${var.runtime}"
  handler       = "${var.handler}"
  timeout       = "${var.timeout}"
  memory_size   = "${var.memory_size}"
  tags          = "${var.tags}"

  environment = ["${slice(list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]
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
  name = "${var.function_name}"

  assume_role_policy = "${data.aws_iam_policy_document.assume_role_policy.json}"
}
