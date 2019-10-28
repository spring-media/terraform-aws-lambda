# Example with CloudWatch scheduled event

Creates an AWS Lambda function triggered by a CloudWatch (scheduled) [event](https://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html).

## requirements

- [Terraform 0.12+](https://www.terraform.io/)
- authentication configuration for the [aws provider](https://www.terraform.io/docs/providers/aws/)

## usage

```bash
$ terraform init
$ terraform plan
```

## bootstrap with func

In case you are using [go](https://golang.org/) for developing your Lambda functions, you can also use [func](https://github.com/spring-media/func) to bootstrap your project and get started quickly:

```
$ func new example-with-cloudwatch
$ cd example-with-cloudwatch && make init package plan
```
