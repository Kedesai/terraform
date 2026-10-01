variable "accounts" {
  type = map(object({
    name = string, email = string, parent_id = string,
    role_name = optional(string), iam_user_access_to_billing = optional(string, "DENY"),
    close_on_deletion = optional(bool, false), tags = optional(map(string), {})
  }))
  default = {}
}
