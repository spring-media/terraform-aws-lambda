# Example with DynamoDb event

Creates an AWS Lambda function triggered by a DynamoDb [event](https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html#supported-event-source-dynamo-db).

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
$ func new example-with-dynamodb -e dynamodb
$ cd example-with-dynamodb && make init package plan
```
