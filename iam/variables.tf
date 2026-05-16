variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume role policy document (JSON string)"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds (3600-43200)"
  type        = number
  default     = 3600
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary policy"
  type        = string
  default     = null
}

variable "inline_policies" {
  description = "Map of inline policies to attach to the role"
  type = map(object({
    policy = string
  }))
  default = {}
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role"
  type        = list(string)
  default     = []
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile for EC2"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional tags to apply to the role"
  type        = map(string)
  default     = {}
}