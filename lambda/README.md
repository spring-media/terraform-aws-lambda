# AWS Lambda Terraform module

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
  source                  = "github.com/spring-media/terraform-aws-lambda"
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
  source              = "github.com/spring-media/terraform-aws-lambda"
  name                = "scheduled-lambda"
  function_name       = "my-scheduled-function"
  handler             = "my-handler"
  s3_bucket           = "some-s3-bucket"
  s3_key              = "some-s3-key"
  schedule_expression = "rate(1 minute)"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of what your Lambda Function does. | string | `` | no |
| function_name | A unique name for your Lambda Function. | string | - | yes |
| handler | The function entrypoint in your code. | string | - | yes |
| log_retention_in_days | Specifies the number of days you want to retain log events in the specified log group. Defaults to 14. | string | `14` | no |
| memory_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | string | `128` | no |
| name | A unique name for this Lambda module. | string | - | yes |
| runtime | The runtime environment for the Lambda function you are uploading. Defaults to go1.x | string | `go1.x` | no |
| s3_bucket | The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function. | string | - | yes |
| s3_key | The S3 key of an object containing the function's deployment package. | string | - | yes |
| schedule_expression | An optional scheduling expression for triggering the Lambda Function using CloudWatch events. For example, cron(0 20 * * ? *) or rate(5 minutes). | string | `` | no |
| stream_batch_size | The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 100. | string | `100` | no |
| stream_enabled | This enables creation of a stream event source mapping for the Lambda function. Defaults to false. | string | `false` | no |
| stream_event_source_arn | An optional event source ARN - can either be a Kinesis or DynamoDB stream. | string | `` | no |
| stream_starting_position | The position in the stream where AWS Lambda should start reading. Must be one of either TRIM_HORIZON or LATEST. Defaults to TRIM_HORIZON. | string | `TRIM_HORIZON` | no |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | string | `3` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) identifying your Lambda Function. |
| function_name | The unique name of your Lambda Function. |
| invoke_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
