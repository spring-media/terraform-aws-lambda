provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = "bucketname"

  lambda_function {
    lambda_function_arn = module.lambda.arn
    events              = ["s3:ObjectCreated:*"]
  }
}

module "lambda" {
  source           = "../../"
  description      = "Example AWS Lambda using go with S3 trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-s3"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  event = {
    type          = "s3"
    s3_bucket_arn = "arn:aws:s3:::bucketname"
    s3_bucket_id  = "bucketname"
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

