provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "../../"
  handler       = "some-handler"
  function_name = "handler"
  description   = "Example for AWS Lambda w/o event trigger."
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"
  memory_size   = "512"
  runtime       = "java8"
  timeout       = 120

  tags {
    key = "value"
  }
}
