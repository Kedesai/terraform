# Example: Complete Infrastructure using all modules
# This demonstrates how to call one or all modules from the terraform repository

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ============================================
# OPTION 1: Call Individual Modules
# ============================================

# Example: Just create a VPC
# module "vpc_only" {
#   source = "git::https://github.com/Kedesai/terraform.git//vpc?ref=main"
#
#   vpc_cidr             = "10.0.0.0/16"
#   environment          = "production"
#   availability_zones   = ["us-east-1a", "us-east-1b"]
#   public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
#   private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
#   enable_nat_gateway   = true
# }

# ============================================
# OPTION 2: Call Multiple Modules
# ============================================

# VPC Module
module "vpc" {
  source = "git::https://github.com/Kedesai/terraform.git//vpc?ref=main"

  vpc_cidr             = "10.0.0.0/16"
  environment          = "production"
  availability_zones   = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]
  enable_nat_gateway   = true

  tags = {
    Project = "complete-infrastructure"
  }
}

# S3 Module
module "s3" {
  source = "git::https://github.com/Kedesai/terraform.git//s3?ref=main"

  bucket_name = "my-complete-app-bucket-$(random_id.bucket_suffix.hex)"
  environment = "production"

  versioning_enabled    = true
  enable_encryption     = true
  enable_lifecycle_rules = true

  tags = {
    Project = "complete-infrastructure"
  }
}

# Random ID for unique bucket name
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# KMS Module (for encryption)
module "kms" {
  source = "git::https://github.com/Kedesai/terraform.git//kms?ref=main"

  key_name    = "complete-app-key"
  environment = "production"

  key_administrators = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/Admin"]
  key_users          = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/AppRole"]

  aliases = ["complete-app-key"]

  tags = {
    Project = "complete-infrastructure"
  }
}

# Data source to get current account info
data "aws_caller_identity" "current" {}

# IAM Module (for Lambda execution role)
module "iam_lambda" {
  source = "git::https://github.com/Kedesai/terraform.git//iam?ref=main"

  role_name          = "complete-app-lambda-role"
  environment        = "production"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = {
    Project = "complete-infrastructure"
  }
}

# IAM Policy Document for Lambda
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# DynamoDB Module
module "dynamodb" {
  source = "git::https://github.com/Kedesai/terraform.git//dynamodb?ref=main"

  table_name    = "complete-app-table"
  environment   = "production"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "id"
  hash_key_type = "S"

  point_in_time_recovery = true
  stream_enabled         = true

  tags = {
    Project = "complete-infrastructure"
  }
}

# SQS Module (Dead Letter Queue)
module "sqs_dlq" {
  source = "git::https://github.com/Kedesai/terraform.git//sqs?ref=main"

  queue_name   = "complete-app-dlq"
  environment  = "production"
}

# SQS Module (Main Queue with DLQ)
module "sqs_main" {
  source = "git::https://github.com/Kedesai/terraform.git//sqs?ref=main"

  queue_name                          = "complete-app-queue"
  environment                         = "production"
  visibility_timeout_seconds          = 60
  message_retention_seconds           = 604800

  redrive_policy_dead_letter_target_arn = module.sqs_dlq.queue_arn
  redrive_policy_max_receive_count      = 5

  tags = {
    Project = "complete-infrastructure"
  }
}

# SNS Module
module "sns" {
  source = "git::https://github.com/Kedesai/terraform.git//sns?ref=main"

  topic_name   = "complete-app-notifications"
  environment  = "production"
  display_name = "Complete App Notifications"

  subscriptions = [
    {
      protocol = "sqs"
      endpoint = module.sqs_main.queue_arn
    }
  ]

  tags = {
    Project = "complete-infrastructure"
  }
}

# ============================================
# Outputs
# ============================================

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_public_subnets" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "vpc_private_subnets" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "s3_bucket_name" {
  description = "S3 bucket name"
  value       = module.s3.bucket_id
}

output "kms_key_arn" {
  description = "KMS key ARN"
  value       = module.kms.key_arn
}

output "lambda_role_arn" {
  description = "Lambda execution role ARN"
  value       = module.iam_lambda.role_arn
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = module.dynamodb.table_arn
}

output "sqs_queue_url" {
  description = "SQS queue URL"
  value       = module.sqs_main.queue_url
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value       = module.sns.topic_arn
}