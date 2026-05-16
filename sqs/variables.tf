variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "fifo_queue" {
  description = "Whether to create a FIFO queue"
  type        = bool
  default     = false
}

variable "content_based_deduplication" {
  description = "Enable content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "delay_seconds" {
  description = "Default delay for messages in seconds (0-900)"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "Maximum message size in bytes (1024-262144)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "Message retention period in seconds (60-1209600)"
  type        = number
  default     = 345600
}

variable "receive_wait_time_seconds" {
  description = "Time to wait for messages during ReceiveMessage (0-20)"
  type        = number
  default     = 0
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout in seconds (0-43200)"
  type        = number
  default     = 30
}

variable "kms_master_key_id" {
  description = "KMS key ID for server-side encryption"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Time to reuse the data key (60-86400)"
  type        = number
  default     = 300
}

variable "redrive_policy_dead_letter_target_arn" {
  description = "ARN of the dead-letter queue"
  type        = string
  default     = null
}

variable "redrive_policy_max_receive_count" {
  description = "Max receive count before sending to DLQ"
  type        = number
  default     = null
}

variable "policy" {
  description = "SQS queue policy (JSON string)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags to apply to the queue"
  type        = map(string)
  default     = {}
}