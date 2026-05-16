# Application Load Balancer
resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups
  subnets            = var.subnets

  ip_address_type              = var.ip_address_type
  enable_deletion_protection   = var.enable_deletion_protection
  enable_http2                 = var.enable_http2
  drop_invalid_header_fields   = var.drop_invalid_header_fields
  idle_timeout                 = var.idle_timeout
  enable_xff_client_port       = var.enable_xff_client_port
  enable_waf_fail_open         = var.enable_waf_fail_open

  tags = merge(
    {
      Name        = var.alb_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# Target Groups
resource "aws_lb_target_group" "this" {
  for_each = { for tg in var.target_groups : tg.name => tg }

  name     = each.value.name
  port     = each.value.port
  protocol = each.value.protocol
  vpc_id   = data.aws_subnet.subnet.vpc_id

  target_type = each.value.target_type

  health_check {
    enabled             = true
    path                = each.value.health_check_path
    protocol            = each.value.health_check_protocol
    interval            = each.value.health_check_interval
    timeout             = each.value.health_check_timeout
    healthy_threshold   = each.value.healthy_threshold
    unhealthy_threshold = each.value.unhealthy_threshold
    matcher             = each.value.health_check_matcher
  }

  stickiness {
    enabled  = each.value.stickiness_enabled
    type     = each.value.stickiness_type
    duration = each.value.stickiness_cookie_duration
  }

  deregistration_delay = each.value.deregistration_delay

  tags = merge(
    {
      Name        = each.value.name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# Get VPC ID from first subnet
data "aws_subnet" "subnet" {
  id = var.subnets[0]
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "this" {
  for_each = {
    for idx, target in flatten([
      for tg in var.target_groups : [
        for t in tg.targets : {
          tg_name = tg.name
          target  = t
        }
      ] if length(tg.targets) > 0
    ]) : "${target.tg_name}-${target.target.target_id}-${idx}" => target
  }

  target_group_arn = aws_lb_target_group.this[each.value.tg_name].arn
  target_id        = each.value.target.target_id
  port             = each.value.target.port
  availability_zone = each.value.target.az
}

# Listeners
resource "aws_lb_listener" "this" {
  for_each = { for idx, listener in var.listeners : idx => listener }

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol
  ssl_policy        = each.value.ssl_policy
  certificate_arn   = each.value.certificate_arn

  dynamic "default_action" {
    for_each = each.value.default_actions
    iterator = action

    content {
      type             = action.value.type
      target_group_arn = action.value.target_group_arn != null ? action.value.target_group_arn : null

      dynamic "redirect" {
        for_each = action.value.redirect_config != null ? [action.value.redirect_config] : []
        content {
          protocol   = redirect.value.protocol
          port       = redirect.value.port
          host       = redirect.value.host
          path       = redirect.value.path
          query      = redirect.value.query
          status_code = redirect.value.status_code
        }
      }

      dynamic "fixed_response" {
        for_each = action.value.fixed_response_config != null ? [action.value.fixed_response_config] : []
        content {
          content_type = fixed_response.value.content_type
          message_body = fixed_response.value.message_body
          status_code  = fixed_response.value.status_code
        }
      }
    }
  }
}