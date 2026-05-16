variable "topic_name" {
  description = "Name of the SNS topic"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "display_name" {
  description = "Display name for the SNS topic (for SMS)"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "KMS key ID for server-side encryption"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Whether to create a FIFO topic"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO topics"
  type        = bool
  default     = false
}

variable "delivery_policy" {
  description = "Delivery policy for the SNS topic (JSON string)"
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "IAM role ARN for application success feedback"
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Sample rate for application success feedback (0-100)"
  type        = number
  default     = null
}

variable "http_success_feedback_role_arn" {
  description = "IAM role ARN for HTTP success feedback"
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Sample rate for HTTP success feedback (0-100)"
  type        = number
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  description = "IAM role ARN for Lambda success feedback"
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Sample rate for Lambda success feedback (0-100)"
  type        = number
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "IAM role ARN for SQS success feedback"
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Sample rate for SQS success feedback (0-100)"
  type        = number
  default     = null
}

variable "subscriptions" {
  description = "List of subscriptions to create"
  type = list(object({
    protocol = string
    endpoint = string
    endpoint_id = optional(string)
    raw_message_delivery = optional(bool, false)
    filter_policy = optional(string)
    filter_policy_scope = optional(string, "MessageAttributes")
  }))
  default = []
}

variable "tags" {
  description = "Additional tags to apply to the topic"
  type        = map(string)
  default     = {}
}