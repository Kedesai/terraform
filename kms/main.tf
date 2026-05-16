# Data source to get current AWS account ID and partition
data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# Default key policy (if not provided)
locals {
  default_key_policy = var.key_policy != null ? var.key_policy : jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:${data.aws_caller_identity.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = var.key_administrators
        }
        Action = [
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:TagResource",
          "kms:UntagResource",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = concat(var.key_users, var.key_grantees)
        }
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ]
        Resource = "*"
      }
    ]
  })
}

# KMS Key
resource "aws_kms_key" "this" {
  description                     = var.description != "" ? var.description : "KMS key for ${var.key_name}"
  key_usage                       = var.key_usage
  customer_master_key_spec        = var.customer_master_key_spec
  deletion_window_in_days         = var.deletion_window_in_days
  enable_key_rotation             = var.enable_key_rotation
  multi_region                    = var.multi_region
  policy                          = local.default_key_policy

  tags = merge(
    {
      Name        = var.key_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# KMS Aliases
resource "aws_kms_alias" "this" {
  for_each = toset(var.aliases)

  name          = "alias/${each.value}"
  target_key_id = aws_kms_key.this.key_id
}