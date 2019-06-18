# AWS Lambda Terraform module

[![Build Status](https://travis-ci.com/spring-media/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/spring-media/terraform-aws-lambda) [![Terraform Module Registry](https://img.shields.io/badge/Terraform%20Module%20Registry-3.0.0-blue.svg)](https://registry.terraform.io/modules/spring-media/lambda/aws/3.0.0) ![Terraform Version](https://img.shields.io/badge/Terraform-0.11.14-green.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with configurable event sources, IAM configuration, VPC as well as SSM/KMS and log streaming support.

The following [event sources](https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html) are supported (see [examples](#examples)):

- `dynamodb`: configures an [Event Source Mapping](https://www.terraform.io/docs/providers/aws/r/lambda_event_source_mapping.html) to trigger the Lambda by DynamoDb events
- `cloudwatch-scheduled-event`: configures a [CloudWatch Event Rule](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html) to trigger the Lambda on a regular, scheduled basis

Furthermore this module supports:

- reading configuration and secrets from [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) including decryption of [SecureString](https://docs.aws.amazon.com/kms/latest/developerguide/services-parameter-store.html) parameters
- [CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) Log group configuration including retention time and [subscription filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html) e.g. to stream logs via Lambda to Elasticsearch

## How do I use this module?

The default configuration of this module is optimized for the `go1.x`runtime, but it can be used for all [runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) supported by AWS Lambda.

In general configure the Lambda function with all required variables and add an event source.

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws"
  version       = "3.0.0"
  filename      = "my-package.zip"
  function_name = "my-function"
  handler       = "my-handler"


  // configurable event trigger
  event {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }

  environment {
    variables {
      loglevel = "INFO"
    }
  }

  // optionally enable VPC access
  vpc_config {
    security_group_ids = ["sg-1"]
    subnet_ids         = ["subnet-1", "subnet-2"]
  }
}
```

### Examples

- [example-with-dynamodb-event-source](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-dynamodb-event)
- [example-with-cloudwatch-scheduled-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-cloudwatch-scheduled-event)
- [example-with-vpc](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-vpc)

## How do I contribute to this module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/spring-media/terraform-aws-lambda/blob/master/CONTRIBUTING.md) for instructions.

## How is this module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release in the [releases page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.

## Inputs

| Name                      | Description                                                                                                                                                                                                                                 |  Type  |  Default  | Required |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----: | :-------: | :------: |
| description               | Description of what your Lambda Function does.                                                                                                                                                                                              | string |   `""`    |    no    |
| environment               | Environment variables are key-value pairs and enable you to dynamically pass settings to your function code and libraries                                                                                                                   |  map   |  `<map>`  |    no    |
| event                     | Event source configuration which triggers the Lambda function. Supported events: Scheduled Events, DynamoDb.                                                                                                                                |  map   |  `<map>`  |    no    |
| filename                  | The path to the function's deployment package within the local filesystem.                                                                                                                                                                  | string |    n/a    |   yes    |
| function_name             | A unique name for your Lambda Function.                                                                                                                                                                                                     | string |    n/a    |   yes    |
| handler                   | The function entrypoint in your code.                                                                                                                                                                                                       | string |    n/a    |   yes    |
| kms_key_arn               | The Amazon Resource Name (ARN) of the KMS key to decrypt AWS Systems Manager parameters.                                                                                                                                                    | string |   `""`    |    no    |
| log_retention_in_days     | Specifies the number of days you want to retain log events in the specified log group. Defaults to 14.                                                                                                                                      | string |  `"14"`   |    no    |
| logfilter_destination_arn | The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN.                                                                                                                                        | string |   `""`    |    no    |
| memory_size               | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128.                                                                                                                                                            | string |  `"128"`  |    no    |
| publish                   | Whether to publish creation/change as new Lambda Function Version. Defaults to true.                                                                                                                                                        | string | `"true"`  |    no    |
| runtime                   | The runtime environment for the Lambda function you are uploading. Defaults to go1.x                                                                                                                                                        | string | `"go1.x"` |    no    |
| ssm_parameter_names       | List of AWS Systems Manager Parameter Store parameters this Lambda will have access to. In order to decrypt secure parameters, a kms_key_arn needs to be provided as well.                                                                  |  list  | `<list>`  |    no    |
| tags                      | A mapping of tags to assign to the Lambda function.                                                                                                                                                                                         |  map   |  `<map>`  |    no    |
| timeout                   | The amount of time your Lambda Function has to run in seconds. Defaults to 3.                                                                                                                                                               | string |   `"3"`   |    no    |
| vpc_config                | Provide this to allow your function to access your VPC (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). |  map   |  `<map>`  |    no    |

## Outputs

| Name          | Description                                                                                                        |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| arn           | The Amazon Resource Name (ARN) identifying your Lambda Function.                                                   |
| function_name | The unique name of your Lambda Function.                                                                           |
| invoke_arn    | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
| role_name     | The name of the IAM role attached to the Lambda Function.                                                          |
