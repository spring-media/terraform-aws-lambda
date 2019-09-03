variable "enable" {
  description = "Conditionally enables this module (and all it's ressources)."
  type        = bool
  default     = false
}

variable "endpoint" {
  description = "The endpoint to send data to (ARN of the Lambda function)"
}

variable "function_name" {
  description = "Name of the Lambda function whose resource policy should be allowed to subscribe to SNS topics."
}

variable "topic_arn" {
  description = "The ARN of the SNS topic to subscribe to"
}

