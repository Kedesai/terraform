variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, production)"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "internal" {
  description = "Whether the ALB is internal (not internet-facing)"
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "IP address type (ipv4 or dualstack)"
  type        = string
  default     = "ipv4"
}

variable "load_balancer_type" {
  description = "Type of load balancer (application or network)"
  type        = string
  default     = "application"
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_http2" {
  description = "Whether to enable HTTP/2 for the ALB"
  type        = bool
  default     = true
}

variable "drop_invalid_header_fields" {
  description = "Whether to drop invalid header fields"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "Idle timeout in seconds"
  type        = number
  default     = 60
}

variable "enable_xff_client_port" {
  description = "Whether to enable X-Forwarded-For client port"
  type        = bool
  default     = false
}

variable "enable_waf_fail_open" {
  description = "Whether to enable WAF fail open"
  type        = bool
  default     = false
}

variable "target_groups" {
  description = "List of target group configurations"
  type = list(object({
    name                       = string
    port                       = number
    protocol                   = optional(string, "HTTP")
    target_type                = optional(string, "instance")
    health_check_path          = optional(string, "/")
    health_check_protocol      = optional(string, "HTTP")
    health_check_interval      = optional(number, 30)
    health_check_timeout       = optional(number, 5)
    healthy_threshold          = optional(number, 5)
    unhealthy_threshold        = optional(number, 2)
    health_check_matcher       = optional(string, "200-299")
    deregistration_delay       = optional(number, 300)
    stickiness_enabled         = optional(bool, false)
    stickiness_type            = optional(string, "lb_cookie")
    stickiness_cookie_duration = optional(number, 86400)
    targets = optional(list(object({
      target_id = string
      port      = optional(number)
      az        = optional(string)
    })), [])
  }))
  default = []
}

variable "listeners" {
  description = "List of listener configurations"
  type = list(object({
    port           = number
    protocol       = optional(string, "HTTP")
    ssl_policy     = optional(string, null)
    certificate_arn = optional(string, null)
    default_actions = list(object({
      type             = string
      target_group_arn = optional(string, null)
      redirect_config  = optional(object({
        protocol   = optional(string, "HTTP")
        port       = optional(string, "80")
        host       = optional(string, "#{host}")
        path       = optional(string, "/#{path}")
        query      = optional(string, "#{query}")
        status_code = optional(string, "HTTP_301")
      }), null)
      fixed_response_config = optional(object({
        content_type = string
        message_body = optional(string, "")
        status_code  = optional(string, "200")
      }), null)
    }))
  }))
  default = []
}

variable "tags" {
  description = "Additional tags to apply to the ALB"
  type        = map(string)
  default     = {}
}