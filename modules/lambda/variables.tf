# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "function_name" {
  description = "A unique name for your Lambda Function."
}

variable "handler" {
  description = "The function entrypoint in your code."
}

variable "runtime" {
  description = "The runtime environment for the Lambda function you are uploading."
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

variable "environment" {
  description = "Environment (e.g. env variables) configuration for the Lambda function enable you to dynamically pass settings to your function code and libraries"
  type        = "map"
  default     = {}
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "security_group_ids" {
  description = "A list of security group IDs associated with the Lambda function. Required in conjunction with 'subnet_ids' if your function should access your VPC."
  type        = "list"
  default     = []
}

variable "subnet_ids" {
  description = "A list of subnet IDs associated with the Lambda function. Required in conjunction with 'security_group_ids' if your function should access your VPC."
  type        = "list"
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
