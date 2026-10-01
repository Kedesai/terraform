module "organization" {
  source = "../organizations"
  feature_set                   = var.feature_set
  enabled_policy_types          = var.enabled_policy_types
  aws_service_access_principals = var.aws_service_access_principals
}

module "organizational_units" {
  source = "../organizational-units"
  organizational_units = {
    for k, v in var.organizational_units : k => {
      name = v.name, parent_id = module.organization.root_id, tags = v.tags
    }
  }
}

module "accounts" {
  source = "../accounts"
  accounts = {
    for k, v in var.accounts : k => {
      name = v.name, email = v.email,
      parent_id = module.organizational_units.organizational_units[v.ou_key].id,
      role_name = v.role_name, iam_user_access_to_billing = v.iam_user_access_to_billing,
      close_on_deletion = v.close_on_deletion, tags = v.tags
    }
  }
}

module "service_control_policies" {
  source   = "../service-control-policies"
  policies = var.service_control_policies
  attachments = {
    for k, v in var.scp_attachments : k => {
      policy_key = v.policy_key
      target_id  = v.target_type == "root" ? module.organization.root_id : module.organizational_units.organizational_units[v.target_key].id
    }
  }
}
