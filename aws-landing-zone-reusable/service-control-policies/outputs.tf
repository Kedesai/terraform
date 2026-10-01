output "policies" { value = { for k, v in aws_organizations_policy.this : k => { id = v.id, arn = v.arn, name = v.name } } }
