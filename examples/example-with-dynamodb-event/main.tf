provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source           = "../../"
  filename         = "${path.module}/test_function.zip"
  function_name    = "my-function"
  handler          = "my-handler"
  runtime          = "go1.x"
  source_code_hash = filebase64sha256("${path.module}/test_function.zip")

  event = {
    type             = "dynamodb"
    event_source_arn = "arn:aws:dynamodb:eu-west-1:647379381847:table/some-table/stream/some-identifier"
  }

  # optionally configure Parameter Store access with decryption
  ssm_parameter_names = ["some/config/root/*"]
  kms_key_arn         = "arn:aws:kms:eu-west-1:647379381847:key/f79f2b-04684-4ad9-f9de8a-79d72f"

  # optionally create a log subscription for streaming log events
  logfilter_destination_arn = "arn:aws:lambda:eu-west-1:647379381847:function:cloudwatch_logs_to_es_production"

  tags = {
    key = "value"
  }
}

