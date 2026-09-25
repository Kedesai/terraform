output "vpc_id" {
  description = "VPC ID"
  value = var.create_vpc ? (
    aws_vpc.this[0].id
  ) : var.existing_vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = var.create_vpc ? aws_vpc.this[0].cidr_block : null
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = var.create_vpc ? aws_subnet.public[*].id : var.existing_public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = var.create_vpc ? aws_subnet.private[*].id : var.existing_private_subnet_ids
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = var.create_vpc ? aws_internet_gateway.this[0].id : null
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = try(aws_route_table.private[0].id, null)
}

output "flow_log_group_arn" {
  description = "The ARN of the CloudWatch log group for flow logs"
  value       = try(aws_cloudwatch_log_group.flow_logs[0].arn, null)
}
