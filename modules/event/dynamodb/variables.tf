variable "enable" {
  description = "Conditionally enables this module (and all it's ressources)."
  default     = 0
}

variable "iam_role_name" {
  description = "The name of the IAM role to attach stream policy configuration."
  default     = ""
}

variable "function_name" {
  description = "The name or the ARN of the Lambda function that will be subscribing to events. "
  default     = ""
}

variable "stream_event_source_arn" {
  description = "Event source ARN of a DynamoDB stream."
  default     = ""
}

variable "stream_starting_position" {
  description = "The position in the stream where AWS Lambda should start reading. Must be one of either TRIM_HORIZON or LATEST. Defaults to TRIM_HORIZON."
  default     = "TRIM_HORIZON"
}
