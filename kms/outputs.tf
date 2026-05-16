output "key_id" {
  description = "The ID of the KMS key"
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "key_alias_arns" {
  description = "List of KMS alias ARNs"
  value       = values(aws_kms_alias.this)[*].arn
}

output "key_alias_names" {
  description = "List of KMS alias names"
  value       = values(aws_kms_alias.this)[*].name
}
</task_progress>
</write_to_file>