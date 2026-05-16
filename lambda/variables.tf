variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime (e.g., python3.11, nodejs20.x, java17)"
  type        = string
}

variable "handler" {
  description = "Lambda handler function"
  type        = string
}

variable "filename" {
  description = "Path to the deployment package (zip file)"
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket containing the deployment package"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of the deployment package"
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "S3 object version of the deployment package"
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Hash of the source code for tracking changes"
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Memory size in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Function timeout in seconds"
  type        = number
  default     = 3
}

variable "role_arn" {
  description = "IAM role ARN for the Lambda function"
  type        = string
}

variable "description" {
  description = "Function description"
  type        = string
  default     = ""
}

variable "environment_variables" {
  description = "Environment variables for the function"
  type        = map(string)
  default     = {}
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting environment variables"
  type        = string
  default     = null
}

variable "tracing_config_mode" {
  description = "Tracing mode (PassThrough or Active)"
  type        = string
  default     = null
}

variable "vpc_subnet_ids" {
  description = "List of VPC subnet IDs for the Lambda function"
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
  default     = []
}

variable "dead_letter_target_arn" {
  description = "ARN of the DLQ (SQS or SNS)"
  type        = string
  default     = null
}

variable "reserved_concurrent_executions" {
  description = "Number of reserved concurrent executions"
  type        = number
  default     = null
}

variable "publish" {
  description = "Whether to publish a version"
  type        = bool
  default     = false
}

variable "layers" {
  description = "List of Lambda layer ARNs"
  type        = list(string)
  default     = []
}

variable "ephemeral_storage_size" {
  description = "Ephemeral storage size in MB (512-10240)"
  type        = number
  default     = 512
}

variable "snap_start" {
  description = "SnapStart configuration (ApplyOn = \"PublishedVersions\" or \"None\")"
  type = object({
    apply_on = string
  })
  default = null
}

variable "tags" {
  description = "Additional tags to apply to the function"
  type        = map(string)
  default     = {}
}