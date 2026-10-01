variable "feature_set" { type = string; default = "ALL" }
variable "enabled_policy_types" { type = list(string); default = ["SERVICE_CONTROL_POLICY"] }
variable "aws_service_access_principals" { type = list(string); default = [] }
