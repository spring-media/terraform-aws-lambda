# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "function_name" {
  description = "A unique name for your Lambda Function."
}

variable "name" {
  description = "A unique name for this Lambda module."
}

variable "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function."
}

variable "s3_key" {
  description = "The S3 key of an object containing the function's deployment package."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------
variable "description" {
  description = "Description of what your Lambda Function does."
  default     = ""
}

variable "handler" {
  description = "The function entrypoint in your code. Defaults to the name var of this module."
  default     = ""
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
  type        = "map"
  default     = {}
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}

variable "event" {
  description = "Event source configuration which triggers the Lambda function. See https://docs.aws.amazon.com/lambda/latest/dg/invoking-lambda-function.html for supported event sources."
  type        = "map"
  default     = {}
}
