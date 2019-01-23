provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "../../modules/lambda"
  handler       = "some-handler"
  function_name = "handler"
  description   = "Example for AWS Lambda w/o event trigger."
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"
  memory_size   = "512"
  runtime       = "go1.x"
  timeout       = 120

  tags {
    key = "value"
  }

  environment {
    variables {
      stage = "dev"
    }
  }
}
