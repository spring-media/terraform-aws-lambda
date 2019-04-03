provider "aws" {
  region = "eu-west-1"
}

data "aws_region" "current" {}

module "lambda" {
  source        = "../../"
  handler       = "example-lambda-func"
  function_name = "tf-example-go-basic"
  description   = "Example AWS Lambda using go w/o event trigger"
  runtime       = "go1.x"
  s3_bucket     = "tf-example-lambda-func-deployment-${data.aws_region.current.name}"
  s3_key        = "v0.1.0/example-lambda-func.zip"

  event {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }

  tags {
    key = "value"
  }

  environment {
    variables {
      key = "value"
    }
  }
}
