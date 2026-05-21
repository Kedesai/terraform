variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance (if not provided, uses latest Amazon Linux 2)"
  type        = string
  default     = null
}

variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "VPC subnet ID for the instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP with the instance"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root EBS volume in GB"
  type        = number
  default     = 8
}

variable "root_volume_type" {
  description = "Type of the root EBS volume (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_kms_key_id" {
  description = "KMS key ID for root volume encryption"
  type        = string
  default     = null
}

variable "additional_ebs_volumes" {
  description = "Additional EBS volumes to attach"
  type = list(object({
    device_name  = string
    volume_size  = number
    volume_type  = optional(string, "gp3")
    encrypted    = optional(bool, true)
    kms_key_id   = optional(string, null)
    delete_on_termination = optional(bool, true)
  }))
  default = []
}

variable "user_data" {
  description = "User data script to run on instance launch"
  type        = string
  default     = null
}

variable "monitoring_enabled" {
  description = "Whether to enable detailed monitoring"
  type        = bool
  default     = true
}

variable "enable_termination_protection" {
  description = "Whether to enable termination protection"
  type        = bool
  default     = false
}

variable "metadata_http_tokens" {
  description = "IMDSv2 token requirement (required or optional)"
  type        = string
  default     = "required"
}

variable "metadata_http_endpoint_enabled" {
  description = "Whether the metadata endpoint is enabled"
  type        = bool
  default     = true
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior when instance is terminated (stop or terminate)"
  type        = string
  default     = "stop"
}

variable "tags" {
  description = "Additional tags to apply to the instance"
  type        = map(string)
  default     = {}
}