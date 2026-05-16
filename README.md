# Terraform AWS Modules

This repository contains a collection of reusable Terraform modules for various AWS services. Each service has its own dedicated folder/module that can be referenced from other repositories.

## Module Structure

Each module follows a consistent structure:

```
module-name/
├── main.tf        # Resource definitions
├── variables.tf   # Input variables
├── outputs.tf     # Output values
├── versions.tf    # Provider version constraints
├── README.md      # Module-specific documentation
└── examples/      # Usage examples
    └── main.tf
```

## Available Modules

| Module | Description |
|--------|-------------|
| `vpc` | VPC with public/private subnets, NAT Gateway, and Internet Gateway |
| `ec2` | EC2 instance with configurable instance type, AMI, and networking |
| `s3` | S3 bucket with versioning, encryption, and lifecycle policies |
| `rds` | RDS instance with Multi-AZ, backup, and monitoring options |
| `lambda` | Lambda function with IAM role, triggers, and environment variables |
| `iam` | IAM roles, policies, and users |
| `alb` | Application Load Balancer with target groups and listeners |
| `dynamodb` | DynamoDB table with on-demand or provisioned capacity |
| `sns` | SNS topic with subscription support |
| `sqs` | SQS queue with dead-letter queue support |
| `cloudfront` | CloudFront distribution with S3 or ALB origin |
| `eks` | EKS cluster with managed node groups |
| `elasticache` | ElastiCache cluster (Redis/Memcached) |
| `kms` | KMS key with key policy and aliases |
| `route53` | Route53 hosted zone and record sets |

## Usage

### Referencing Modules from Another Repository

You can reference these modules from any other Terraform configuration by using the Git repository URL:

```hcl
module "vpc" {
  source = "git::https://github.com/<your-username>/Terraform.git//vpc?ref=v1.0.0"

  vpc_cidr = "10.0.0.0/16"
  environment = "production"
  availability_zones = ["us-east-1a", "us-east-1b"]
}

module "s3" {
  source = "git::https://github.com/<your-username>/Terraform.git//s3?ref=v1.0.0"

  bucket_name = "my-application-bucket"
  environment = "production"
}
```

### Module Calling Syntax

```hcl
module "<module_name>" {
  source = "git::https://github.com/<your-username>/Terraform.git//<service_folder>?ref=<version_tag>"

  # Required and optional variables
  variable_name = "value"
}
```

## Tagging Strategy

All modules support a consistent tagging strategy:

```hcl
tags = {
  Name        = "resource-name"
  Environment = "production"
  Project     = "my-project"
  ManagedBy   = "terraform"
}
```

## Requirements

- Terraform >= 1.0.0
- AWS Provider >= 5.0

## Contributing

1. Create a new branch for your module
2. Follow the existing module structure
3. Add comprehensive documentation
4. Include examples in the `examples/` directory
5. Submit a pull request

## License

MIT License