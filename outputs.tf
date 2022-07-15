
output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = module.lambda.arn
}
output "aws_lambda_function_url" {
  description = "The unique url to invoke your lambda function"
  value       = var.enable_functionurl ? aws_lambda_function_url.lambda_url[0].function_url : ""
}
/*
output "function_name" {
  description = "The unique name of your Lambda Function."
  value       = module.lambda.function_name
}

output "invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
  value       = module.lambda.invoke_arn
}

output "role_name" {
  description = "The name of the IAM role attached to the Lambda Function."
  value       = module.lambda.role_name
}

*/