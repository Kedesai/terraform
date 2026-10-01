variable "policies" {
  type = map(object({ name = string, description = optional(string), content = string, tags = optional(map(string), {}) }))
  default = {}
}
variable "attachments" {
  type = map(object({ policy_key = string, target_id = string }))
  default = {}
  validation {
    condition     = alltrue([for a in values(var.attachments) : contains(keys(var.policies), a.policy_key)])
    error_message = "Every attachment policy_key must identify an entry in policies."
  }
}
