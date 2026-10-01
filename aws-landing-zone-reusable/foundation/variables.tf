variable "feature_set" { type = string; default = "ALL" }
variable "enabled_policy_types" { type = list(string); default = ["SERVICE_CONTROL_POLICY"] }
variable "aws_service_access_principals" { type = list(string); default = [] }
variable "organizational_units" {
  description = "Top-level OUs under the organization root."
  type = map(object({ name = string, tags = optional(map(string), {}) }))
  default = {}
}
variable "accounts" {
  description = "Accounts. ou_key selects one of organizational_units."
  type = map(object({
    name = string, email = string, ou_key = string, role_name = optional(string),
    iam_user_access_to_billing = optional(string, "DENY"), close_on_deletion = optional(bool, false),
    tags = optional(map(string), {})
  }))
  default = {}
  validation {
    condition     = alltrue([for a in values(var.accounts) : contains(keys(var.organizational_units), a.ou_key)])
    error_message = "Every account ou_key must identify an entry in organizational_units."
  }
}
variable "service_control_policies" {
  type = map(object({ name = string, description = optional(string), content = string, tags = optional(map(string), {}) }))
  default = {}
}
variable "scp_attachments" {
  description = "Attach SCPs to root or OU. target_type is root or ou; target_key is required for ou."
  type = map(object({ policy_key = string, target_type = string, target_key = optional(string) }))
  default = {}
  validation {
    condition = alltrue([for a in values(var.scp_attachments) :
      contains(keys(var.service_control_policies), a.policy_key) &&
      contains(["root", "ou"], a.target_type) &&
      (a.target_type == "root" || (a.target_key != null && contains(keys(var.organizational_units), a.target_key)))
    ])
    error_message = "SCP attachment must reference an existing policy and a valid root/OU target."
  }
}
