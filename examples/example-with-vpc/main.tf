provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source           = "../../"
  description      = "Example AWS Lambda inside a VPC using go with cloudwatch scheduled event trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-basic-vpc"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  vpc_config = {
    subnet_ids         = ["subnet-123456", "subnet-123457"]
    security_group_ids = ["sg-123456"]
  }

  event = {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
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

