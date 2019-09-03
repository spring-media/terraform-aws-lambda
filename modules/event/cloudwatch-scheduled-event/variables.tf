variable "enable" {
  description = "Conditionally enables this module (and all it's ressources)."
  type        = bool
  default     = false
}

variable "lambda_function_arn" {
  description = "The Amazon Resource Name (ARN) identifying the Lambda Function trigger by CloudWatch"
}

variable "schedule_expression" {
  description = "Scheduling expression for triggering the Lambda Function using CloudWatch events. For example, cron(0 20 * * ? *) or rate(5 minutes)."
}

