# AWS Lambda Terraform module

[![Build Status](https://travis-ci.com/spring-media/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/spring-media/terraform-aws-lambda) [![Terraform Module Registry](https://img.shields.io/badge/Terraform%20Module%20Registry-3.0.1-blue.svg)](https://registry.terraform.io/modules/spring-media/lambda/aws/3.0.1) ![Terraform Version](https://img.shields.io/badge/Terraform-0.11.14-green.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

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
  version       = "3.0.1"
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
