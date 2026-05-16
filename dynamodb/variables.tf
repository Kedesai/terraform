variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode (PAY_PER_REQUEST or PROVISIONED)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity units (required if billing_mode is PROVISIONED)"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "Write capacity units (required if billing_mode is PROVISIONED)"
  type        = number
  default     = null
}

variable "hash_key" {
  description = "Name of the hash key (partition key)"
  type        = string
}

variable "range_key" {
  description = "Name of the range key (sort key)"
  type        = string
  default     = null
}

variable "hash_key_type" {
  description = "Type of the hash key (S, N, or B)"
  type        = string
  default     = "S"
}

variable "range_key_type" {
  description = "Type of the range key (S, N, or B)"
  type        = string
  default     = "S"
}

variable "attributes" {
  description = "Additional attribute definitions for indexes"
  type = list(object({
    name = string
    type = string
  }))
  default = []
}

variable "global_secondary_indexes" {
  description = "List of global secondary indexes"
  type = list(object({
    name            = string
    hash_key        = optional(string)
    range_key       = optional(string)
    projection_type = optional(string, "ALL")
    non_key_attributes = optional(list(string), null)
    write_capacity  = optional(number)
    read_capacity   = optional(number)
  }))
  default = []
}

variable "local_secondary_indexes" {
  description = "List of local secondary indexes"
  type = list(object({
    name            = string
    range_key       = string
    projection_type = optional(string, "ALL")
    non_key_attributes = optional(list(string), null)
  }))
  default = []
}

variable "point_in_time_recovery" {
  description = "Whether to enable point-in-time recovery"
  type        = bool
  default     = false
}

variable "ttl_attribute" {
  description = "Attribute name for TTL"
  type        = string
  default     = null
}

variable "stream_enabled" {
  description = "Whether to enable DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type (NEW_IMAGE, OLD_IMAGE, NEW_AND_OLD_IMAGES, KEYS_ONLY)"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "server_side_encryption_kms_key_arn" {
  description = "KMS key ARN for server-side encryption"
  type        = string
  default     = null
}

variable "deletion_protection_enabled" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the table"
  type        = map(string)
  default     = {}
}