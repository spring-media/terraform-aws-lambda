variable "enable" {
  description = "Conditionally enables this module (and all it's ressources)."
  default     = 0
}

variable "target_group_arn" {
  description = "The ARN of the lambda that will act as the load balancers target group."
}
