output "alb_id" {
  description = "The ID of the Application Load Balancer"
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "alb_zone_id" {
  description = "The Route 53 Hosted Zone ID for the ALB"
  value       = aws_lb.this.zone_id
}

output "target_group_arns" {
  description = "List of target group ARNs"
  value       = values(aws_lb_target_group.this)[*].arn
}

output "target_group_names" {
  description = "List of target group names"
  value       = values(aws_lb_target_group.this)[*].name
}

output "listener_arns" {
  description = "List of listener ARNs"
  value       = values(aws_lb_listener.this)[*].arn
}