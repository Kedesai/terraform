variable "organizational_units" {
  type = map(object({ name = string, parent_id = string, tags = optional(map(string), {}) }))
  default = {}
}
