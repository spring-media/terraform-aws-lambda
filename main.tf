module "lambda" {
  source                         = "app.terraform.io/bankrate/lambda-function/aws"
  version                        = "~> 4.0.0"
  handler                        = var.handler
  publish                        = var.publish
  reserved_concurrent_executions = var.reserved_concurrent_executions
  runtime                        = var.runtime
  timeout                        = var.timeout
  tags                           = var.tags
  layers                         = var.layers
  resource_allocation            = var.resource_allocation
  vpc_tag                        = var.vpc_tag_key_override
  name                           = var.name
  team_name                      = var.team_name
  environment                    = var.environment

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

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lambda" {
  name               = var.name
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

module "lambda_cloudwatch_trigger" {
  source  = "app.terraform.io/bankrate/lambda-cloudwatch-trigger/aws"
  version = "~> 4.0.0"

  # Enablement
  enable = var.enable && lookup(var.architecture, "cloudwatch_trigger", false)

  lambda_function_arn = module.lambda.arn
  schedule_expression = var.schedule_expression
  environment         = var.environment
  project             = var.project
  owner               = var.owner
}

module "lambda_s3_trigger" {
  source  = "app.terraform.io/bankrate/lambda-s3-trigger/aws"
  version = "~> 1.0.0"

  # Enablement
  enable = var.enable && lookup(var.architecture, "s3_trigger", false)

  bucket_name         = var.bucket_id
  lambda_function_arn = module.lambda.arn
}

module "lambda_ddb_trigger" {
  source  = "app.terraform.io/bankrate/lambda-event-source/aws"
  version = "2.3.0"

  # Enablement
  enable = var.enable && lookup(var.architecture, "ddb_trigger", false)

  lambda_function_arn = module.lambda.arn
  lambda_role_name    = module.lambda.iam_role_name
  event_source_arn    = var.event_source_arn
  event_source_type   = "dynamodb"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${module.lambda.name}"
  retention_in_days = var.log_retention_in_days
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
  name        = "${module.lambda.name}-ssm-${count.index}"
  description = "Provides minimum Parameter Store permissions for ${module.lambda.name}."
  policy      = data.aws_iam_policy_document.ssm_policy_document[count.index].json
}

resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  count      = length(var.ssm_parameter_names)
  role       = module.lambda.iam_role_name
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
  name        = "${module.lambda.name}-kms"
  description = "Provides minimum KMS permissions for ${module.lambda.name}."
  policy      = data.aws_iam_policy_document.kms_policy_document.json
}

resource "aws_iam_role_policy_attachment" "kms_policy_attachment" {
  count      = var.kms_key_arn != "" ? 1 : 0
  role       = module.lambda.iam_role_name
  policy_arn = aws_iam_policy.kms_policy[count.index].arn
}

resource "aws_lambda_function_url" "lambda_url" {
  count              = var.enable && lookup(var.architecture, "function_url", false) ? 1 : 0
  function_name      = module.lambda.arn
  authorization_type = var.authorization_type
}