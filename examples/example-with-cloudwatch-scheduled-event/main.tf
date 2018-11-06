provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "../../"
  handler       = "some-handler"
  function_name = "handler"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"

  event {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }

  # optionally configure Parameter Store access with decryption
  ssm_parameter_names = ["some/config/root/*"]
  kms_key_arn         = "arn:aws:kms:eu-west-1:647379381847:key/f79f2b-04684-4ad9-f9de8a-79d72f"

  # optionlly create a log subscription for streaming log events
  logfilter_destination_arn = "arn:aws:lambda:eu-west-1:647379381847:function:cloudwatch_logs_to_es_production"

  tags {
    key = "value"
  }
}
