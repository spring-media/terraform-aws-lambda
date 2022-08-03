provider "aws" {
  region  = "us-east-1"
  version = "4.11.0"
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_security_group" "lambda_egress" {
  name        = "lambda-egress-qa"
  description = "Allow egress from Lambda functions"
  vpc_id      = "PrimaryVPC"
}

resource "aws_security_group_rule" "lambda_egress" {
  type      = "egress"
  from_port = 0
  to_port   = 0
  protocol  = "-1"

  security_group_id = aws_security_group.lambda_egress.id
  cidr_blocks       = ["0.0.0.0/0"]
}

module "lambda" {
  source      = "../../"
  description = "Example AWS Lambda inside a VPC using go with cloudwatch scheduled event trigger"
  filename    = "${path.module}/test_function.zip"
  name        = "tf-example-go-basic"
  handler     = "example-lambda-func"
  runtime     = "go1.x"
  service     = "example"
  project     = "example"
  environment = "qa"
  team_name   = "example"
  owner       = "example"

  architecture = {
    cloudwatch_trigger = true
    s3_trigger         = false
    ddb_trigger        = false
    function_url       = false
    kinesis_trigger    = false
    sqs_trigger        = false
  }
  
  schedule_expression = "rate(1 minute)"
  create_in_vpc       = true
  create_default_sg   = false
  security_groups     = [aws_security_group.lambda_egress.id]

  tags = {
    key = "value"
  }
}

