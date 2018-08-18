variable "name" {
  description = "The name of the REST API."
}

variable "description" {
  description = "The description of the REST API."
  default     = ""
}

variable "stage_name" {
  description = "The name of the stage (production/staging/etc..)."
}

variable "http_method" {
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)."
  default     = "GET"
}

variable "lambda_invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri."
}

variable "lambda_arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function called by API Gateway."
}
