variable "name" {
  description = "A unique name for this Lambda module."
}

variable "function_name" {
  description = "A unique name for your Lambda Function."
}

variable "description" {
  description = "Description of what your Lambda Function does."
  default     = ""
}

variable "s3_bucket" {
  description = "The S3 bucket location containing the function's deployment package. This bucket must reside in the same AWS region where you are creating the Lambda function."
}

variable "s3_key" {
  description = "The S3 key of an object containing the function's deployment package."
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds. Defaults to 3."
  default     = 3
}

variable "runtime" {
  description = "The runtime environment for the Lambda function you are uploading. Defaults to go1.x"
  default     = "go1.x"
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128."
  default     = 128
}

variable "handler" {
  description = "The function entrypoint in your code."
}

variable "schedule_expression" {
  description = "An optional scheduling expression for triggering the Lambda Function using CloudWatch events. For example, cron(0 20 * * ? *) or rate(5 minutes)."
  default     = ""
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Defaults to 14."
  default     = 14
}

variable "stream_batch_size" {
  description = "The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 100."
  default     = 100
}

variable "stream_event_source_arn" {
  description = "An optional event source ARN - can either be a Kinesis or DynamoDB stream."
  default     = ""
}

variable "stream_enabled" {
  description = "This enables creation of a stream event source mapping for the Lambda function. Defaults to false."
  default     = false
}

variable "stream_starting_position" {
  description = "The position in the stream where AWS Lambda should start reading. Must be one of either TRIM_HORIZON or LATEST. Defaults to TRIM_HORIZON."
  default     = "TRIM_HORIZON"
}
