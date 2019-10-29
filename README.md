# AWS Lambda Terraform module

[![Build Status](https://travis-ci.com/spring-media/terraform-aws-lambda.svg?branch=master)](https://travis-ci.com/spring-media/terraform-aws-lambda) [![Terraform Module Registry](https://img.shields.io/badge/Terraform%20Module%20Registry-4.3.0-blue.svg)](https://registry.terraform.io/modules/spring-media/lambda/aws/4.3.0) ![Terraform Version](https://img.shields.io/badge/Terraform-0.12.11-green.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with configurable event sources, IAM configuration (following the [principal of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege)), VPC as well as SSM/KMS and log streaming support.

The following [event sources](https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html) are supported (see [examples](#examples)):

- [cloudwatch-scheduled-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-cloudwatch-scheduled-event): configures a [CloudWatch Event Rule](https://www.terraform.io/docs/providers/aws/r/cloudwatch_event_rule.html) to trigger the Lambda on a regular, scheduled basis
- [dynamodb](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-dynamodb-event): configures an [Event Source Mapping](https://www.terraform.io/docs/providers/aws/r/lambda_event_source_mapping.html) to trigger the Lambda by DynamoDb events
- [s3](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-s3-event): configures permission to trigger the Lambda by S3
- [sns](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-sns-event): to trigger Lambda by [SNS Topic Subscription](https://www.terraform.io/docs/providers/aws/r/sns_topic_subscription.html)

Furthermore this module supports:

- reading configuration and secrets from [AWS Systems Manager Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-paramstore.html) including decryption of [SecureString](https://docs.aws.amazon.com/kms/latest/developerguide/services-parameter-store.html) parameters
- [CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/Working-with-log-groups-and-streams.html) Log group configuration including retention time and [subscription filters](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/SubscriptionFilters.html) e.g. to stream logs via Lambda to Elasticsearch

## Terraform version compatibility

| module | terraform |     branch      |
| :----: | :-------: | :-------------: |
| 4.x.x  |  0.12.x   |     master      |
| 3.x.x  |  0.11.x   | terraform_0.11x |

## How do I use this module?

The module can be used for all [runtimes](https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html) supported by AWS Lambda (defaults to `go1.x`).

In general configure the Lambda function with all required variables and add an (optional) event source (see [variables.tf](https://github.com/spring-media/terraform-aws-lambda/blob/master/variables.tf) for all available options).

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws"
  version       = "4.3.0"
  filename      = "my-package.zip"
  function_name = "my-function"
  handler       = "my-handler"
  runtime       = "go1.x"

  // configurable event trigger, see examples
  event = {
    type                = "cloudwatch-scheduled-event"
    schedule_expression = "rate(1 minute)"
  }

  // optionally set environment configuration
  environment = {
    variables {
      loglevel = "INFO"
    }
  }

  // optionally enable VPC access
  vpc_config = {
    security_group_ids = ["sg-1"]
    subnet_ids         = ["subnet-1", "subnet-2"]
  }

  # optionally configure Parameter Store access with decryption
  ssm_parameter_names = ["some/config/root/*"]
  kms_key_arn         = "arn:aws:kms:eu-west-1:647379381847:key/f79f2b-04684-4ad9-f9de8a-79d72f"

  # optionally create a log subscription for streaming log events from CloudWatch to ElasticSearch
  logfilter_destination_arn = "arn:aws:lambda:eu-west-1:647379381847:function:cloudwatch_logs_to_es_production"
}
```

### Examples

- [example-with-cloudwatch-scheduled-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-cloudwatch-scheduled-event)
- [example-with-dynamodb-event-source](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-dynamodb-event)
- [example-with-s3-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-s3-event)
- [example-with-sns-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-sns-event)
- [example-with-vpc](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-vpc)
- [example-without-event](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-without-event)

### bootstrap with func

In case you are using [go](https://golang.org/) for developing your Lambda functions, you can also use [func](https://github.com/spring-media/func) to bootstrap your project and get started quickly.

## How do I contribute to this module?

Contributions are very welcome! Check out the [Contribution Guidelines](https://github.com/spring-media/terraform-aws-lambda/blob/master/CONTRIBUTING.md) for instructions.

## How is this module versioned?

This Module follows the principles of [Semantic Versioning](http://semver.org/). You can find each new release in the [releases page](../../releases).

During initial development, the major version will be 0 (e.g., `0.x.y`), which indicates the code does not yet have a
stable API. Once we hit `1.0.0`, we will make every effort to maintain a backwards compatible API and use the MAJOR,
MINOR, and PATCH versions on each release to indicate any incompatibilities.
