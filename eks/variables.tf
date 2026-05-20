variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.29"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    desired_size   = number
    min_size       = number
    max_size       = number
    capacity_type  = string
  }))
  default = {}
}

variable "enable_cluster_creator_admin" {
  type    = bool
  default = true
}

variable "tags" {
  type    = map(string)
  default = {}
}