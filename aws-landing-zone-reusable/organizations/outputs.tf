output "id" { value = aws_organizations_organization.this.id }
output "arn" { value = aws_organizations_organization.this.arn }
output "root_id" { value = aws_organizations_organization.this.roots[0].id }
