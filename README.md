# AWS Lambda Terraform module [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform module which creates Lambda resources on AWS.

These types of resources are supported:

* [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html)

These events are supported:

* Stream events using [Event Source Mapping](https://www.terraform.io/docs/providers/aws/r/lambda_event_source_mapping.html) (currently only DynamoDb)
* Scheduled events using [CloudWatch](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html) 

## Usage

with event source mapping:

```
module "stream-lambda" {
  source                  = "git@github.com:spring-media/terraform-aws-lambda.git"
  name                    = "stream-lambda"
  function_name           = "my-dynamodb-stream-function"
  handler                 = "my-handler"
  s3_bucket               = "some-s3-bucket"
  s3_key                  = "some-s3-key"
  stream_enabled          = true
  stream_event_source_arn = "arn:aws:dynamodb:REGION:123456789012:stream/stream_name"
}
```

with scheduled event:

```
module "scheduled-lambda" {
  source              = "git@github.com:spring-media/terraform-aws-lambda.git"
  name                = "scheduled-lambda"
  function_name       = "my-scheduled-function"
  handler             = "my-handler"
  s3_bucket           = "some-s3-bucket"
  s3_key              = "some-s3-key"
  schedule_expression = "rate(1 minute)"
}
```


## Inputs

Todo

## Outputs

Todo

## License

MIT Licensed. See LICENSE for full details.