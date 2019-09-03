provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "../../"
  description   = "Example AWS Lambda using go with cloudwatch scheduled event trigger"
  filename      = "test_function.zip"
  function_name = "tf-example-go-basic"
  handler       = "example-lambda-func"
  runtime       = "go1.x"

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
