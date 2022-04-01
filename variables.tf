
## var scratchpad
## required banking vars (generally provided by workspace)
variable "app_name" {
  type = string
  description = "describe your variable"
}
variable "environment" {
  type = string
  description = "describe your variable"
}
## optional vars for RV modules should default but be exposed
variable "resource_allocation" {
  type = string
  description = "(optional) describe your variable"
  default = "low"
}
variable "enable_newrelic" {
  type = bool
  description = "(optional) describe your variable"
  default = false
}

#
## Enablement and Architecture Toggles
###
variable architecture {
  description = "Triggers are not required. Chose which trigger, if any, to use with lambda.  If one is true, all others must be false."
  type = object({
    cloudwatch_trigger             = bool
    s3_trigger                     = bool
    ddb_trigger                    = bool
  })

  default = {
    cloudwatch_trigger             = false
    s3_trigger                     = false
    ddb_trigger                    = false
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "filename" {
  description = "The path to the function's deployment package within the local filesystem."
}

variable "function_name" {
  description = "A unique name for your Lambda Function."
}

variable "handler" {
  description = "The function entrypoint in your code."
}

variable "project" {
  description = "Name of the project this falls under."
}

variable "service" {
  description = "Name of the service this is used in."
}

variable "owner" {
  description = "Name of the owner or vertical this belongs to."
}

variable "team_name" {
  description = "Name of the team this belongs to."
}

variable "resource_allocation" {
  description = "Name of the project this falls under."
  default = "low"
}


# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "description" {
  description = "Description of what your Lambda Function does."
  default     = ""
}

variable "environment" {
  description = "Environment (e.g. env variables) configuration for the Lambda function enable you to dynamically pass settings to your function code and libraries"
  type        = map(map(string))
  default     = {}
}

variable "event" {
  description = "Event source configuration which triggers the Lambda function. Supported events: cloudwatch-scheduled-event, dynamodb, s3, sns"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the KMS key to decrypt AWS Systems Manager parameters."
  default     = ""
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Defaults to 14."
  default     = 14
}

variable "logfilter_destination_arn" {
  description = "The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN."
  default     = ""
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version. Defaults to true."
  default     = true
}

variable "reserved_concurrent_executions" {
  description = "The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1."
  default     = "-1"
}

variable "runtime" {
  description = "The runtime environment for the Lambda function you are uploading. Defaults to go1.x"
  default     = "go1.x"
}

variable "ssm_parameter_names" {
  description = "List of AWS Systems Manager Parameter Store parameters this Lambda will have access to. In order to decrypt secure parameters, a kms_key_arn needs to be provided as well."
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the Lambda function."
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}

variable "vpc_config" {
  description = "Provide this to allow your function to access your VPC (if both 'subnet_ids' and 'security_group_ids' are empty then vpc_config is considered to be empty or unset, see https://docs.aws.amazon.com/lambda/latest/dg/vpc.html for details)."
  type        = map(list(string))
  default     = {}
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. See [Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html)"
  type        = list(string)
  default     = []
}
