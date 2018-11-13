# AWS Lambda Terraform module [![Build Status](https://travis-ci.com/spring-media/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/spring-media/terraform-aws-lambda) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with configurable event sources, IAM role configuration as well as SSM/KMS and log streaming support.

The following [event sources](https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html) are supported (see [examples](#examples)):

* ` dynamodb`: configures an [Event Source Mapping](https://www.terraform.io/docs/providers/aws/r/lambda_event_source_mapping.html) to trigger the Lambda by DynamoDb events
* `cloudwatch-scheduled-event`: configures a [CloudWatch Event Rule](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html) to trigger the Lambda on a regular, scheduled basis

Furthermore this module supports:

* reading configuration and secrets from [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) including decryption of [SecureString](https://docs.aws.amazon.com/kms/latest/developerguide/services-parameter-store.html) parameters
* [CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) Log group configuration including retention time and [subscription filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html) e.g. to stream logs via Lambda to Elasticsearch

## How to use this module

The default configuration of this module is optimized for the `go1.x`runtime, but it can be used for all [runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) supported by AWS Lambda. For an opinionated example how to use this Lambda module in a golang project, see [lambda-blueprint](https://github.com/spring-media/lambda-blueprint).

In general configure the Lambda function with all mandatory variables and add an event source. Make sure, that `s3_bucket` and `s3_key` point to an existing archive.

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws"
  version       = "2.4.1"
  handler       = "some-handler"
  function_name = "handler"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"

  event {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }
}
```

## Examples

* [example-with-basic-function](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-basic-function)
* [example-with-dynamodb-event-source](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-dynamodb-event)
* [example-with-cloudwatch-scheduled-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-cloudwatch-scheduled-event)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of what your Lambda Function does. | string | `` | no |
| event | Event source configuration which triggers the Lambda function. Supported events: Scheduled Events, DynamoDb. | map | `<map>` | no |
| function\_name | A unique name for your Lambda Function. | string | - | yes |
| handler | The function entrypoint in your code. | string | - | yes |
| kms\_key\_arn | The Amazon Resource Name (ARN) of the KMS key to decrypt AWS Systems Manager parameters. | string | `` | no |
| log\_retention\_in\_days | Specifies the number of days you want to retain log events in the specified log group. Defaults to 14. | string | `14` | no |
| logfilter\_destination\_arn | The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN. | string | `` | no |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | string | `128` | no |
| runtime | The runtime environment for the Lambda function you are uploading. Defaults to go1.x | string | `go1.x` | no |
| s3\_bucket | The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function. | string | - | yes |
| s3\_key | The S3 key of an object containing the function's deployment package. | string | - | yes |
| ssm\_parameter\_names | List of AWS Systems Manager Parameter Store parameters this Lambda will have access to. In order to decrypt secure parameters, a kms_key_arn needs to be provided as well. | list | `<list>` | no |
| tags | A mapping of tags to assign to the Lambda function. | map | `<map>` | no |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | string | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) identifying your Lambda Function. |
| function\_name | The unique name of your Lambda Function. |
| invoke\_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
| role\_name | The name of the IAM role attached to the Lambda Function. |
