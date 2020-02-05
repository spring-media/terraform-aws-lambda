# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "iam_role_name" {
  description = "The name of the IAM role to attach stream policy configuration."
}

variable "function_name" {
  description = "The name or the ARN of the Lambda function that will be subscribing to events. "
}

variable "event_source_arn" {
  description = "Event source ARN of a SQS queue."
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "batch_size" {
  default     = 10
  description = "The largest number of records that Lambda will retrieve from your event source at the time of invocation. Defaults to 10 for SQS."
}

variable "enable" {
  default     = false
  description = "Conditionally enables this module (and all it's ressources)."
}

variable "event_source_mapping_enabled" {
  default     = true
  description = "Determines if the mapping will be enabled on creation. Defaults to true."
}
