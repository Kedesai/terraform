variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "acl" {
  description = "Canned ACL for the bucket (deprecated, use access control rules)"
  type        = string
  default     = null
}

variable "versioning_enabled" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "enable_encryption" {
  description = "Whether to enable server-side encryption"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_arn" {
  description = "KMS master key ARN for encryption (required if sse_algorithm is aws:kms)"
  type        = string
  default     = null
}

variable "block_public_acls" {
  description = "Whether to block public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Whether to block public bucket policies"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Whether to ignore public ACLs"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Whether to restrict public bucket policies"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Whether to enable lifecycle rules"
  type        = bool
  default     = false
}

variable "lifecycle_transition_days" {
  description = "Number of days after which to transition to Standard-IA"
  type        = number
  default     = 30
}

variable "lifecycle_glacier_days" {
  description = "Number of days after which to transition to Glacier"
  type        = number
  default     = 90
}

variable "lifecycle_expiration_days" {
  description = "Number of days after which to expire objects"
  type        = number
  default     = 365
}

variable "enable_access_logging" {
  description = "Whether to enable S3 access logging"
  type        = bool
  default     = false
}

variable "log_target_bucket" {
  description = "Target bucket for access logs"
  type        = string
  default     = null
}

variable "log_target_prefix" {
  description = "Prefix for log object keys"
  type        = string
  default     = "logs/"
}

variable "cors_configuration" {
  description = "CORS configuration for the bucket"
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default = null
}

variable "website_configuration" {
  description = "Website configuration for static hosting"
  type = object({
    index_document = optional(string)
    error_document = optional(string)
    routing_rules  = optional(string)
  })
  default = null
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (including non-empty buckets)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the bucket"
  type        = map(string)
  default     = {}
}