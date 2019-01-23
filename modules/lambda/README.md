# Lambda Module

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with IAM role configuration.

## How to use this module

Configure the Lambda function with all mandatory variables:

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws//modules/lambda"
  version       = "2.4.1"
  handler       = "some-handler"
  function_name = "handler"
  runtime       = "go1.x"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"
}
```

## Examples

* [example-with-basic-function](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/example-with-basic-function)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| description | Description of what your Lambda Function does. | string | `` | no |
| function\_name | A unique name for your Lambda Function. | string | - | yes |
| handler | The function entrypoint in your code. | string | - | yes |
| memory\_size | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | string | `128` | no |
| runtime | The runtime environment for the Lambda function you are uploading. | string | - | yes |
| s3\_bucket | The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function. | string | - | yes |
| s3\_key | The S3 key of an object containing the function's deployment package. | string | - | yes |
| tags | A mapping of tags to assign to the Lambda function. | map | `<map>` | no |
| timeout | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | string | `3` | no |
| environment | A map of environment configuration (e.g. variables) which pass into lambda code | `<map>` | - | no |


## Outputs

| Name | Description |
|------|-------------|
| arn | The Amazon Resource Name (ARN) identifying your Lambda Function. |
| function\_name | The unique name of your Lambda Function. |
| invoke\_arn | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
| role\_name | The name of the IAM attached to the Lambda Function. |
