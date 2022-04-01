  module "lambda" {
  source                         = "app.terraform.io/Bankrate/lambda-function/aws"
  version                        = "~> 3.0.0" # Only pull patch/fix releases
  description                    = var.description
  filename                       = var.filename
  handler                        = var.handler
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  timeout                        = var.timeout
  tags                           = var.tags
  vpc_config                     = var.vpc_config
  layers                         = var.layers

 # additions from RV standard
  name                = var.function_name
  project             = var.project_name
  service             = var.service
  owner               = var.owner # || vertical
  team_name           = var.team_name
  resource_allocation = var.resource_allocation

  # Additions from old lambda sub-module
  /*
  dynamic "environment" {
    for_each = length(var.environment) < 1 ? [] : [var.environment]
    content {
      variables = environment.value.variables
    }
  }

  function_name                  = var.function_name
  memory_size                    = var.memory_size
  role                           = aws_iam_role.lambda.arn
  source_code_hash               = filebase64sha256(var.filename)

  dynamic "vpc_config" {
    for_each = length(var.vpc_config) < 1 ? [] : [var.vpc_config]
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnet_ids         = vpc_config.value.subnet_ids
    }
  }
  */

  # bonus points
  #create_in_vpc     = var.create_in_vpc
  #create_default_sg = var.create_default_sg
  #enable_newrelic = var.enable_newrelic
  #security_groups = concat(var.security_groups, tolist(aws_security_group.lambda_egress.id))
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda" {
  name               = var.function_name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "vpc_attachment" {
  count = length(var.vpc_config) < 1 ? 0 : 1
  role  = aws_iam_role.lambda.name

  // see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

/*
module "event-cloudwatch-scheduled-event" {
  source = "./modules/event/cloudwatch-scheduled-event"
  enable = lookup(var.event, "type", "") == "cloudwatch-scheduled-event" ? true : false
  architecture = {}

  lambda_function_arn = module.lambda.arn
  schedule_expression = lookup(var.event, "schedule_expression", "")
}
*/

module "lambda_cloudwatch_trigger" {
  source  = "app.terraform.io/bankrate/lambda-cloudwatch-trigger/aws"
  version = "~> 4.0.0"
  
  # Enablement
  architecture = var.architecture
  enable = {
    enable              = var.enable
    lambda_function_arn = module.lambda.arn
    schedule_expression = lookup(var.event, "schedule_expression", "")
    environment         = var.environment
    project             = var.project_name
    owner               = var.owner
  }


}

/*
module "event-s3" {
  source = "./modules/event/s3"
  enable = lookup(var.event, "type", "") == "s3" ? true : false
  architecture = {}

  lambda_function_arn = module.lambda.arn
  s3_bucket_arn       = lookup(var.event, "s3_bucket_arn", "")
  s3_bucket_id        = lookup(var.event, "s3_bucket_id", "")
}
*/

module "lambda_s3_trigger" {
  source = "app.terraform.io/bankrate/lambda-s3-trigger/aws"
  version = "~> 1.0.0"

  bucket_name         = lookup(var.event, "s3_bucket_id", "")
  lambda_function_arn = module.lambda.arn
}

/*
module "event-dynamodb" {
  source = "./modules/event/dynamodb"
  enable = lookup(var.event, "type", "") == "dynamodb" ? true : false
  architecture = {}

  function_name           = module.lambda.function_name
  iam_role_name           = module.lambda.role_name
  stream_event_source_arn = lookup(var.event, "stream_event_source_arn", "")
  table_name              = lookup(var.event, "table_name", "")
}
*/

module "lambda_ddb_trigger" {
  source  = "app.terraform.io/bankrate/lambda-event-source/aws"
  version = "~> 2.0.0"

  lambda_function_arn = module.lambda.arn
  lambda_role_name    = module.lambda.role_name
  event_source_arn    = lookup(var.event, "stream_event_source_arn", "")
  event_source_type   = "dynamodb"
}

/*
module "event-sns" {
  source = "./modules/event/sns"
  enable = lookup(var.event, "type", "") == "sns" ? true : false
  architecture = {}

  endpoint      = module.lambda.arn
  function_name = module.lambda.function_name
  topic_arn     = lookup(var.event, "topic_arn", "")
}
*/


resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${module.lambda.function_name}"
  retention_in_days =  var.log_retention_in_days
}

resource "aws_lambda_permission" "cloudwatch_logs" {
  count         = var.logfilter_destination_arn != "" ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.logfilter_destination_arn
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = aws_cloudwatch_log_group.lambda.arn
}

resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_logs_to_es" {
  depends_on      = [aws_lambda_permission.cloudwatch_logs]
  count           = var.logfilter_destination_arn != "" ? 1 : 0
  name            = "elasticsearch-stream-filter"
  log_group_name  = aws_cloudwatch_log_group.lambda.name
  filter_pattern  = ""
  destination_arn = var.logfilter_destination_arn
  distribution    = "ByLogStream"
}

data "aws_iam_policy_document" "ssm_policy_document" {
  count = length(var.ssm_parameter_names)

  statement {
    actions = [
      "ssm:GetParameters",
      "ssm:GetParametersByPath",
    ]

    resources = [
      "arn:aws:ssm:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:parameter/${element(var.ssm_parameter_names, count.index)}",
    ]
  }
}

resource "aws_iam_policy" "ssm_policy" {
  count       = length(var.ssm_parameter_names)
  name        = "${module.lambda.function_name}-ssm-${count.index}"
  description = "Provides minimum Parameter Store permissions for ${module.lambda.function_name}."
  policy      = data.aws_iam_policy_document.ssm_policy_document[count.index].json
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  count      = length(var.ssm_parameter_names)
  role       = module.lambda.role_name
  policy_arn = aws_iam_policy.ssm_policy[count.index].arn
}

data "aws_iam_policy_document" "kms_policy_document" {
  statement {
    actions = [
      "kms:Decrypt",
    ]

    resources = [
      var.kms_key_arn,
    ]
  }
}

resource "aws_iam_policy" "kms_policy" {
  count       = var.kms_key_arn != "" ? 1 : 0
  name        = "${module.lambda.function_name}-kms"
  description = "Provides minimum KMS permissions for ${module.lambda.function_name}."
  policy      = data.aws_iam_policy_document.kms_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  count      = var.kms_key_arn != "" ? 1 : 0
  role       = module.lambda.role_name
  policy_arn = aws_iam_policy.kms_policy[count.index].arn
} 

