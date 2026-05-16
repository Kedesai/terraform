# VPC Module

This module creates a complete VPC infrastructure with public and private subnets, Internet Gateway, NAT Gateway, and optional VPC Flow Logs.

## Features

- VPC with configurable CIDR block
- Public subnets with auto-assigned public IPs
- Private subnets for internal resources
- Internet Gateway for public subnet internet access
- NAT Gateway for private subnet outbound internet access
- Route tables with appropriate routes
- Optional VPC Flow Logs for network monitoring

## Usage

```hcl
module "vpc" {
  source = "git::https://github.com/<your-username>/Terraform.git//vpc?ref=v1.0.0"

  vpc_cidr             = "10.0.0.0/16"
  environment          = "production"
  availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  enable_nat_gateway   = true
  enable_flow_logs     = true

  tags = {
    Project = "my-project"
  }
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
| vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, production) | `string` | n/a | yes |
| availability_zones | List of availability zones | `list(string)` | n/a | yes |
| public_subnet_cidrs | List of CIDR blocks for public subnets | `list(string)` | `[]` | no |
| private_subnet_cidrs | List of CIDR blocks for private subnets | `list(string)` | `[]` | no |
| enable_nat_gateway | Whether to create NAT Gateway for private subnets | `bool` | `false` | no |
| single_nat_gateway | Whether to use a single NAT Gateway for all private subnets | `bool` | `true` | no |
| enable_dns_hostnames | Whether to enable DNS hostnames in the VPC | `bool` | `true` | no |
| enable_dns_support | Whether to enable DNS support in the VPC | `bool` | `true` | no |
| enable_flow_logs | Whether to enable VPC Flow Logs | `bool` | `false` | no |
| flow_logs_traffic_type | Type of traffic to capture in flow logs (ACCEPT, REJECT, ALL) | `string` | `"ALL"` | no |
| tags | Additional tags to apply to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr | The CIDR block of the VPC |
| public_subnet_ids | List of public subnet IDs |
| private_subnet_ids | List of private subnet IDs |
| internet_gateway_id | The ID of the Internet Gateway |
| nat_gateway_ids | List of NAT Gateway IDs |
| public_route_table_id | The ID of the public route table |
| private_route_table_id | The ID of the private route table |
| flow_log_group_arn | The ARN of the CloudWatch log group for flow logs |