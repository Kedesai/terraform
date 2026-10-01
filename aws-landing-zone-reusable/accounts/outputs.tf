output "accounts" {
  value = { for k, v in aws_organizations_account.this : k => { id = v.id, arn = v.arn, name = v.name, parent_id = v.parent_id } }
}
