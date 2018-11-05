# AWS Lambda Terraform module [![Build Status](https://travis-ci.com/spring-media/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/spring-media/terraform-aws-lambda) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources.

These [event sources](https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html) are supported:

* DynamoDb stream events using [Event Source Mapping](https://www.terraform.io/docs/providers/aws/r/lambda_event_source_mapping.html)
* Scheduled events using [CloudWatch](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html)

Furthermore this module supports:

* reading configuration and secrets from [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) including decryption of [SecureString](https://docs.aws.amazon.com/kms/latest/developerguide/services-parameter-store.html) parameters
* [CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) Log group configuration including retention time and [subscription filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html) e.g. to stream logs via Lambda to Elasticsearch

## Examples

with CloudWatch event source:

```
module "lambda" {
  source        = "github.com/spring-media/terraform-aws-lambda"
  name          = "scheduled"
  function_name = "lambda-blueprint-scheduled-fct"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.version}/scheduled.zip"

  event {
    type                = "cloudwatch-event"
    schedule_expression = "rate(1 minute)"
  }
}
```

with DynamoDb stream event source: 

```
module "lambda" {
  source        = "github.com/spring-media/terraform-aws-lambda"
  name          = "stream"
  function_name = "lambda-blueprint-stream-fct"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.version}/stream.zip"

  event {
    type                             = "dynamodb"
    schedule_stream_event_source_arn = "arn:..."
  }
}
```

adding ssm support:

```
data "aws_kms_key" "kms" {
  key_id = "alias/my_key"
}

module "lambda" {
  source        = "github.com/spring-media/terraform-aws-lambda"
  name          = "scheduled"
  function_name = "lambda-blueprint-scheduled-fct"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.version}/scheduled.zip"

  event {
    type                = "cloudwatch-event"
    schedule_expression = "rate(1 minute)"
  }

  ssm_parameter_names = ["some/nested/param", "some/other/nested/param/*"]
  kms_key_arn         = "${data.aws_kms_key.kms.arn}"
}
```

adding CloudWatch Logs to Lambda/Elasticsearch stream subscription:

```
data "aws_lambda_function" "logging_lambda" {
  function_name = "LogsToElasticsearch_production-logs"
}

module "lambda" {
  source        = "github.com/spring-media/terraform-aws-lambda"
  name          = "scheduled"
  function_name = "lambda-blueprint-scheduled-fct"
  s3_bucket     = "${var.s3_bucket}"
  s3_key        = "${var.version}/scheduled.zip"

  event {
    type                = "cloudwatch-event"
    schedule_expression = "rate(1 minute)"
  }

  // see https://github.com/terraform-providers/terraform-provider-aws/issues/4446 why we use replace here
  logfilter_destination_arn = "${replace(data.aws_lambda_function.logging_lambda.arn,":$LATEST","")}"
}

```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of what your Lambda Function does. | string | `` | no |
| event | Event source configuration which triggers the Lambda function. See https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html for supported event sources. | map | `<map>` | no |
| function_name | A unique name for your Lambda Function. | string | - | yes |
| handler | The function entrypoint in your code. Defaults to the name var of this module. | string | `` | no |
| kms_key_arn | The Amazon Resource Name (ARN) of the KMS key to decrypt AWS Systems Manager parameters. | string | `` | no |
| log_retention_in_days | Specifies the number of days you want to retain log events in the specified log group. Defaults to 14. | string | `14` | no |
| logfilter_destination_arn | The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN. | string | `` | no |
| memory_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | string | `128` | no |
| name | A unique name for this Lambda module. | string | - | yes |
| runtime | The runtime environment for the Lambda function you are uploading. Defaults to go1.x | string | `go1.x` | no |
| s3_bucket | The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function. | string | - | yes |
| s3_key | The S3 key of an object containing the function's deployment package. | string | - | yes |
| ssm_parameter_names | List of AWS Systems Manager Parameter Store parameters this Lambda will have access to. In order to decrypt secure parameters, a kms_key_arn needs to be provided as well. | list | `<list>` | no |
| tags | A mapping of tags to assign to the Lambda function. | map | `<map>` | no |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | string | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) identifying your Lambda Function. |
| function_name | The unique name of your Lambda Function. |
| invoke_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
