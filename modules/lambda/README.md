# Lambda Module

Terraform module to create AWS [Lambda](https://www.terraform.io/docs/providers/aws/r/lambda_function.html) resources with IAM role configuration and VPC support.

## How to use this module

Configure the Lambda function with all required variables:

```
provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "spring-media/lambda/aws//modules/lambda"
  filename      = "my-package.zip"
  function_name = "my-function"
  handler       = "my-handler"
  runtime       = "go1.x"
}
```
