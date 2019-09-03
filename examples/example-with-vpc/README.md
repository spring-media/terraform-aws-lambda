# Example with VPC and CloudWatch scheduled event

Creates an AWS Lambda function inside a VPC triggered by a CloudWatch (scheduled) [event](https://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html).

## requirements

- [Terraform 0.12+](https://www.terraform.io/)
- authentication configuration for the [aws provider](https://www.terraform.io/docs/providers/aws/)

## usage

To generate and show the execution plan run

```
terraform init
terraform plan
```
