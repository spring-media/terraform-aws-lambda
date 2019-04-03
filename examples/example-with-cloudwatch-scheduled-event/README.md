# Example with CloudWatch scheduled event

Creates an AWS Lambda function triggered by a CloudWatch (scheduled) [event](https://docs.aws.amazon.com/lambda/latest/dg/with-scheduled-events.html).

## requirements

- [Terraform 0.11.7+](https://www.terraform.io/)
- authentication configuration for the [aws provider](https://www.terraform.io/docs/providers/aws/)

## usage

To generate and show the execution plan run

```
terraform init
terraform plan
```

To build or change real infrastructure on AWS (**this will create costs**) create
an S3 deployment bucket (`make s3-init`) and upload a go function (`make package`)
using the [Makefile](https://github.com/spring-media/terraform-aws-lambda/tree/master/examples/functions/go-basic) and then

```
terraform apply
```

In order to save costs cleanup afterwards

```
terraform destroy
make -f func/Makefile s3-destroy
```
