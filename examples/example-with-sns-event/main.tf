provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source           = "../../"
  description      = "Example AWS Lambda using go with sns trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-sns"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  event = {
    type      = "sns"
    topic_arn = "arn:aws:sns:eu-west-1:123456789123:test-topic"
  }

  tags = {
    key = "value"
  }

  environment = {
    variables = {
      key = "value"
    }
  }
}

