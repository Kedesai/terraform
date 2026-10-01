resource "aws_organizations_account" "this" {
  for_each                   = var.accounts
  name                       = each.value.name
  email                      = each.value.email
  parent_id                  = each.value.parent_id
  role_name                  = each.value.role_name
  iam_user_access_to_billing = each.value.iam_user_access_to_billing
  close_on_deletion          = each.value.close_on_deletion
  tags                       = each.value.tags
}
