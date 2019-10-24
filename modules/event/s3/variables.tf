# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "lambda_function_arn" {
  description = "The Amazon Resource Name (ARN) identifying the Lambda Function triggered by S3"
}

variable "s3_bucket_arn" {
  description = "The ARN of the bucket."
}

variable "s3_bucket_id" {
  description = "The name of the bucket."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "enable" {
  description = "Conditionally enables this module (and all it's ressources)."
  type        = bool
  default     = false
}
