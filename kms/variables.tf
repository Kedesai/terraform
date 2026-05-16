variable "key_name" {
  description = "Name of the KMS key"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = ""
}

variable "key_usage" {
  description = "The cryptographic operations for which you can use the key (ENCRYPT_DECRYPT or SIGN_VERIFY)"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "customer_master_key_spec" {
  description = "Specifies the type of KMS key (SYMMETRIC_DEFAULT, RSA_2048, RSA_3072, RSA_4096, ECC_NIST_P256, etc.)"
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted (7-30)"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Whether to enable automatic key rotation"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Whether the KMS key is a multi-Region key"
  type        = bool
  default     = false
}

variable "key_policy" {
  description = "Key policy document (JSON string). If not provided, a default policy is used."
  type        = string
  default     = null
}

variable "key_administrators" {
  description = "List of IAM ARNs for key administrators"
  type        = list(string)
  default     = []
}

variable "key_users" {
  description = "List of IAM ARNs for key users"
  type        = list(string)
  default     = []
}

variable "key_grantees" {
  description = "List of IAM ARNs for key grantees (for encrypt/decrypt only)"
  type        = list(string)
  default     = []
}

variable "aliases" {
  description = "List of aliases for the KMS key"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to apply to the key"
  type        = map(string)
  default     = {}
}