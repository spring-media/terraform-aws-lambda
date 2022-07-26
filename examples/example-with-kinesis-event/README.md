# Example with Kinesis event

Creates an AWS Lambda function triggered by a Kinesis [event](https://docs.aws.amazon.com/lambda/latest/dg/with-kinesis.html).

## requirements

- [Terraform 0.12+](https://www.terraform.io/)
- authentication configuration for the [aws provider](https://www.terraform.io/docs/providers/aws/)

## usage

```
$ terraform init
$ terraform plan
```

## bootstrap with func

In case you are using [go](https://golang.org/) for developing your Lambda functions, you can also use [func](https://github.com/spring-media/func) to bootstrap your project and get started quickly:

```
$ func new example-with-kinesis -e kinesis
$ cd example-with-kinesis && make init package plan
```
