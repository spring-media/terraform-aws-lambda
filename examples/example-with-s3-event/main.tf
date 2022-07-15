provider "aws" {
  region  = "us-east-1"
  version = "4.11.0"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "bucketname"

  lambda_function {
    lambda_function_arn = module.lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

module "lambda" {
  source      = "../../"
  description = "Example AWS Lambda using go with s3 event trigger"
  filename    = "${path.module}/test_function.zip"
  name        = "tf-example-go-basic"
  handler     = "example-lambda-func"
  runtime     = "go1.x"
  service     = "example"
  project     = "example"
  environment = "qa"
  team_name   = "example"
  owner       = "example"

  architecture = {
    cloudwatch_trigger = false
    s3_trigger         = true
    ddb_trigger        = false
    function_url       = false
  }
  bucket_arn = "arn:aws:s3:::bucketname"
  bucket_id  = "bucketname"

  tags = {
    key = "value"
  }



}

