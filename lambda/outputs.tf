output "function_name" {
  description = "The unique name of your Lambda Function."
  value       = "${aws_lambda_function.lambda.*.function_name[0]}"
}

output "arn" {
  description = "The Amazon Resource Name (ARN) identifying your Lambda Function."
  value       = "${aws_lambda_function.lambda.*.arn[0]}"
}

output "invoke_arn" {
  description = "The ARN to be used for invoking Lambda Function from API Gateway - to be used in aws_api_gateway_integration's uri"
  value       = "${aws_lambda_function.lambda.*.invoke_arn[0]}"
}
