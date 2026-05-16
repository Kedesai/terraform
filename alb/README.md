# ALB Module

This module creates an Application Load Balancer (ALB) with configurable target groups, listeners, and health checks.

## Features

- Application Load Balancer with configurable settings
- Multiple target groups with health checks
- Listener configuration with SSL/TLS support
- Target registration
- Session stickiness
- Deletion protection
- HTTP/2 support

## Usage

### Basic ALB with HTTP Listener

```hcl
module "alb" {
  source = "git::https://github.com/<your-username>/Terraform.git//alb?ref=v1.0.0"

  alb_name        = "my-alb"
  environment     = "production"
  subnets         = ["subnet-12345678", "subnet-87654321"]
  security_groups = ["sg-12345678"]

  target_groups = [
    {
      name              = "web-tg"
      port              = 80
      health_check_path = "/health"
      targets = [
        {
          target_id = "i-1234567890abcdef0"
          port      = 80
        },
        {
          target_id = "i-0987654321fedcba0"
          port      = 80
        }
      ]
    }
  ]

  listeners = [
    {
      port     = 80
      protocol = "HTTP"
      default_actions = [
        {
          type             = "forward"
          target_group_arn = module.alb.target_group_arns[0]
        }
      ]
    }
  ]

  tags = {
    Application = "my-app"
  }
}
```

### ALB with HTTPS and SSL

```hcl
module "alb_https" {
  source = "git::https://github.com/<your-username>/Terraform.git//alb?ref=v1.0.0"

  alb_name        = "my-secure-alb"
  environment     = "production"
  subnets         = ["subnet-12345678", "subnet-87654321"]
  security_groups = ["sg-12345678"]

  internal = false

  target_groups = [
    {
      name              = "web-tg"
      port              = 443
      protocol          = "HTTPS"
      health_check_path = "/health"
      targets = [
        {
          target_id = "i-1234567890abcdef0"
          port      = 443
        }
      ]
    }
  ]

  listeners = [
    {
      port           = 443
      protocol       = "HTTPS"
      ssl_policy     = "ELBSecurityPolicy-TLS-1-2-2017-01"
      certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/abc-123"
      default_actions = [
        {
          type             = "forward"
          target_group_arn = module.alb_https.target_group_arns[0]
        }
      ]
    },
    {
      port     = 80
      protocol = "HTTP"
      default_actions = [
        {
          type = "redirect"
          redirect_config = {
            protocol   = "HTTPS"
            port       = "443"
            status_code = "HTTP_301"
          }
        }
      ]
    }
  ]

  enable_deletion_protection = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb_name | Name of the Application Load Balancer | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| subnets | List of subnet IDs for the ALB | `list(string)` | n/a | yes |
| security_groups | List of security group IDs for the ALB | `list(string)` | n/a | yes |
| internal | Whether the ALB is internal | `bool` | `false` | no |
| ip_address_type | IP address type (ipv4 or dualstack) | `string` | `"ipv4"` | no |
| load_balancer_type | Type of load balancer | `string` | `"application"` | no |
| enable_deletion_protection | Whether to enable deletion protection | `bool` | `false` | no |
| enable_http2 | Whether to enable HTTP/2 | `bool` | `true` | no |
| drop_invalid_header_fields | Whether to drop invalid header fields | `bool` | `false` | no |
| idle_timeout | Idle timeout in seconds | `number` | `60` | no |
| enable_xff_client_port | Whether to enable X-Forwarded-For client port | `bool` | `false` | no |
| enable_waf_fail_open | Whether to enable WAF fail open | `bool` | `false` | no |
| target_groups | List of target group configurations | `list(object)` | `[]` | no |
| listeners | List of listener configurations | `list(object)` | `[]` | no |
| tags | Additional tags to apply to the ALB | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| alb_id | The ID of the Application Load Balancer |
| alb_arn | The ARN of the Application Load Balancer |
| alb_dns_name | The DNS name of the Application Load Balancer |
| alb_zone_id | The Route 53 Hosted Zone ID for the ALB |
| target_group_arns | List of target group ARNs |
| target_group_names | List of target group names |
| listener_arns | List of listener ARNs |