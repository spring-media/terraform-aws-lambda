# Lambda Module

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with IAM role configuration and VPC support.

## How to use this module

Configure the Lambda function with all mandatory variables:

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws//modules/lambda"
  handler       = "some-handler"
  function_name = "handler"
  runtime       = "go1.x"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"
}
```

## Inputs

| Name          | Description                                                                                                                                                                                                                                 |  Type  | Default | Required |
| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----: | :-----: | :------: |
| description   | Description of what your Lambda Function does.                                                                                                                                                                                              | string |  `""`   |    no    |
| environment   | Environment (e.g. env variables) configuration for the Lambda function enable you to dynamically pass settings to your function code and libraries                                                                                          |  map   | `<map>` |    no    |
| function_name | A unique name for your Lambda Function.                                                                                                                                                                                                     | string |   n/a   |   yes    |
| handler       | The function entrypoint in your code.                                                                                                                                                                                                       | string |   n/a   |   yes    |
| memory_size   | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128.                                                                                                                                                            | string | `"128"` |    no    |
| runtime       | The runtime environment for the Lambda function you are uploading.                                                                                                                                                                          | string |   n/a   |   yes    |
| s3_bucket     | The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function.                                                                             | string |   n/a   |   yes    |
| s3_key        | The S3 key of an object containing the function's deployment package.                                                                                                                                                                       | string |   n/a   |   yes    |
| tags          | A mapping of tags to assign to the Lambda function.                                                                                                                                                                                         |  map   | `<map>` |    no    |
| timeout       | The amount of time your Lambda Function has to run in seconds. Defaults to 3.                                                                                                                                                               | string |  `"3"`  |    no    |
| vpc_config    | Provide this to allow your function to access your VPC (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details). |  map   | `<map>` |    no    |

## Outputs

| Name          | Description                                                                                                        |
| ------------- | ------------------------------------------------------------------------------------------------------------------ |
| arn           | The Amazon Resource Name (ARN) identifying your Lambda Function.                                                   |
| function_name | The unique name of your Lambda Function.                                                                           |
| invoke_arn    | The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri |
| role_name     | The name of the IAM attached to the Lambda Function.                                                               |
