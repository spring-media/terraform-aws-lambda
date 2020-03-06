provider "aws" {
  region = "eu-west-1"
}

module "lambda-scheduled" {
  source           = "../../"
  description      = "Example AWS Lambda using go with cloudwatch scheduled event trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-basic"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  event = {
    type                = "cloudwatch-event"
    schedule_expression = "rate(1 minute)"
  }
}

module "lambda-pattern" {
  source           = "../../"
  description      = "Example AWS Lambda using go with cloudwatch event pattern trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-basic"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  event = {
    type          = "cloudwatch-event"
    event_pattern = <<PATTERN
    {
      "detail-type": [
        "AWS Console Sign In via CloudTrail"
      ]
    }
    PATTERN
  }
}
