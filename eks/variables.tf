variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.28"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "cluster_role_arn" {
  description = "Existing IAM role ARN for EKS control plane"
  type        = string
  default     = null
}

variable "node_role_arn" {
  description = "Existing IAM role ARN for worker nodes"
  type        = string
  default     = null
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
  }))
  default = {}
}

variable "enable_cluster_creator_admin" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}


#################################
# PIPELINE METADATA
#################################

variable "pipeline_name" {
  description = "CI/CD pipeline that triggered Terraform"
  type        = string
  default     = "local" # fallback if not passed
}

variable "run_id" {
  description = "Pipeline run ID for tracking"
  type        = string
  default     = "manual"
}

variable "created_by" {
  description = "User running Terraform"
  type        = string
}