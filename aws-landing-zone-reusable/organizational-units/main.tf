resource "aws_organizations_organizational_unit" "this" {
  for_each  = var.organizational_units
  name      = each.value.name
  parent_id = each.value.parent_id
  tags      = each.value.tags
}
