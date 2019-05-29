resource "aws_lambda_function" "lambda" {
  description      = "${var.description}"
  environment      = ["${slice(list(var.environment), 0, length(var.environment) == 0 ? 0 : 1 )}"]
  filename         = "${var.filename}"
  function_name    = "${var.function_name}"
  handler          = "${var.handler}"
  memory_size      = "${var.memory_size}"
  publish          = "${var.publish}"
  role             = "${aws_iam_role.lambda.arn}"
  runtime          = "${var.runtime}"
  source_code_hash = "${filebase64sha256(var.filename)}"
  tags             = "${var.tags}"
  timeout          = "${var.timeout}"

  vpc_config {
    security_group_ids = ["${var.vpc_config["security_group_ids"]}"]
    subnet_ids         = ["${var.vpc_config["subnet_ids"]}"]
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
  count = "${(length(var.vpc_config["security_group_ids"]) > 0 && length(var.vpc_config["subnet_ids"]) > 0) ? 1 : 0}"
  role  = "${aws_iam_role.lambda.name}"

  // see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}
