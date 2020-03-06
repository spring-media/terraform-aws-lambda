provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source           = "../../"
  description      = "Example AWS Lambda using go with cloudwatch scheduled event trigger"
  filename         = "${path.module}/test_function.zip"
  function_name    = "tf-example-go-basic"
  handler          = "example-lambda-func"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")
}
