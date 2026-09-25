# EC2 Module

This module creates an EC2 instance with configurable options for instance type, AMI, networking, storage, and security.

## Features

- EC2 instance with configurable instance type
- Automatic AMI lookup (Amazon Linux 2) or custom AMI
- Configurable root and additional EBS volumes
- IMDSv2 support for enhanced security
- User data script support
- Termination protection
- Detailed monitoring
- Encrypted EBS volumes with optional KMS key

## Usage

### Basic Instance

```hcl
module "ec2" {
  source = "git::https://github.com/<your-username>/Terraform.git//ec2?ref=v1.0.0"

  instance_name = "my-instance"
  environment   = "production"
  subnet_id     = "subnet-12345678"
}
```

### Instance with Custom Configuration

```hcl
module "ec2" {
  source = "git::https://github.com/<your-username>/Terraform.git//ec2?ref=v1.0.0"

  instance_name          = "web-server"
  environment            = "production"
  instance_type          = "t3.medium"
  subnet_id              = "subnet-12345678"
  key_name               = "my-key-pair"
  vpc_security_group_ids = ["sg-12345678"]
  associate_public_ip    = true

  root_volume_size  = 50
  root_volume_type  = "gp3"

  additional_ebs_volumes = [
    {
      device_name = "/dev/sdb"
      volume_size = 100
      volume_type = "gp3"
      encrypted   = true
    }
  ]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
  EOF

  tags = {
    Role = "web-server"
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
| instance_name | Name of the EC2 instance | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, production) | `string` | n/a | yes |
| instance_type | EC2 instance type | `string` | `"t3.micro"` | no |
| ami_id | AMI ID for the instance | `string` | `null` | no |
| key_name | EC2 Key Pair name for SSH access | `string` | `null` | no |
| subnet_id | VPC subnet ID for the instance | `string` | n/a | yes |
| vpc_security_group_ids | List of security group IDs | `list(string)` | `[]` | no |
| associate_public_ip | Whether to associate a public IP | `bool` | `false` | no |
| root_volume_size | Size of the root EBS volume in GB | `number` | `8` | no |
| root_volume_type | Type of the root EBS volume | `string` | `"gp3"` | no |
| root_volume_encrypted | Whether to encrypt the root volume | `bool` | `true` | no |
| root_volume_kms_key_id | KMS key ID for root volume encryption | `string` | `null` | no |
| additional_ebs_volumes | Additional EBS volumes to attach | `list(object)` | `[]` | no |
| user_data | User data script to run on instance launch | `string` | `null` | no |
| monitoring_enabled | Whether to enable detailed monitoring | `bool` | `true` | no |
| enable_termination_protection | Whether to enable termination protection | `bool` | `false` | no |
| metadata_http_tokens | IMDSv2 token requirement (required or optional) | `string` | `"required"` | no |
| metadata_http_endpoint_enabled | Whether the metadata endpoint is enabled | `bool` | `true` | no |
| instance_initiated_shutdown_behavior | Shutdown behavior (stop or terminate) | `string` | `"stop"` | no |
| tags | Additional tags to apply to the instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The ID of the EC2 instance |
| instance_arn | The ARN of the EC2 instance |
| public_ip | The public IP address (if assigned) |
| private_ip | The private IP address |
| public_dns | The public DNS name (if assigned) |
| private_dns | The private DNS name |
| availability_zone | The availability zone of the instance |

## Calling Module

This reusable module is consumed from the deployment repository:

```text
Kedesai/call-terraform/ec2
```

### Module Source

```hcl
module "ec2" {
  source = "git::https://github.com/Kedesai/terraform.git//ec2?ref=main"

  instance_name = var.instance_name
  environment   = var.environment
  instance_type = var.instance_type

  ami_owner = var.ami_owner
  ami_name  = var.ami_name

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.vpc_security_group_ids

  associate_public_ip = false

  root_volume_size      = var.root_volume_size
  root_volume_type      = var.root_volume_type
  root_volume_encrypted = true

  tags = var.tags
}
```

For production deployments, use a Git tag or commit SHA rather than `ref=main`.

## Required Calling Parameters

The calling configuration must provide:

```text
instance_name
environment
subnet_id
```

The deployment also normally provides:

```text
aws_region
instance_type
ami_owner
ami_name
vpc_security_group_ids
root_volume_size
root_volume_type
tags
```

### Approved AMI

Example:

```hcl
ami_owner = "853826937896"
ami_name  = "UBUNTU-22-PRO-x86 2026-09-01T08-00-32.122Z"
```

### Existing Networking

The calling configuration provides existing networking:

```hcl
subnet_id = "subnet-xxxxxxxx"

vpc_security_group_ids = [
  "sg-xxxxxxxx"
]
```

The EC2 module does not need to create the VPC, subnet, or security group.

## HCP Terraform

Typical workspace configuration:

```text
Repository:           Kedesai/call-terraform
Working Directory:    ec2
VCS Trigger:          Branch-based
VCS Branch:           Default branch
Trigger Pattern:      ec2/**/*
Speculative PR Plans: Enabled
Auto Apply:           Disabled
```

### Terraform Variables

Environment-specific values can be supplied through the HCP Terraform workspace, including:

```text
aws_region
instance_name
environment
```

Structured non-secret values such as subnet IDs, security groups, AMI selection, instance sizing, and tags may also be defined in the calling configuration.

## AWS Credentials

AWS access keys, secret keys, and session tokens must **not** be committed to either GitHub repository.

Do not store AWS credentials in:

```text
main.tf
variables.tf
terraform.tfvars
README.md
```

AWS authentication should be supplied by HCP Terraform, such as through a shared Variable Set or dynamic AWS credentials.

## GitOps Workflow

```text
Feature Branch
      ↓
Pull Request
      ↓
HCP Terraform Speculative Plan
      ↓
Review and Merge
      ↓
HCP Terraform Plan
      ↓
Manual Apply
      ↓
AWS
```
