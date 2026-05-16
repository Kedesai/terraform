# IAM Module

This module creates an IAM role with configurable assume role policy, inline policies, managed policy attachments, and optional instance profile for EC2.

## Features

- IAM role with custom assume role policy
- Inline policy support
- Managed policy attachments
- Permissions boundary support
- Optional instance profile for EC2
- Configurable max session duration

## Usage

### Basic IAM Role for Lambda

```hcl
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

module "iam_lambda" {
  source = "git::https://github.com/<your-username>/Terraform.git//iam?ref=v1.0.0"

  role_name          = "my-lambda-role"
  environment        = "production"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]

  tags = {
    Application = "my-app"
  }
}
```

### IAM Role for EC2 with Instance Profile

```hcl
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "iam_ec2" {
  source = "git::https://github.com/<your-username>/Terraform.git//iam?ref=v1.0.0"

  role_name               = "my-ec2-role"
  environment             = "production"
  assume_role_policy      = data.aws_iam_policy_document.ec2_assume_role.json
  create_instance_profile = true

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]

  inline_policies = {
    S3Access = {
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect   = "Allow"
            Action   = ["s3:GetObject", "s3:PutObject"]
            Resource = "arn:aws:s3:::my-bucket/*"
          }
        ]
      })
    }
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
| role_name | Name of the IAM role | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| assume_role_policy | Assume role policy document (JSON string) | `string` | n/a | yes |
| description | Description of the IAM role | `string` | `""` | no |
| max_session_duration | Maximum session duration in seconds (3600-43200) | `number` | `3600` | no |
| permissions_boundary | ARN of the permissions boundary policy | `string` | `null` | no |
| inline_policies | Map of inline policies to attach to the role | `map(object)` | `{}` | no |
| managed_policy_arns | List of managed policy ARNs to attach | `list(string)` | `[]` | no |
| create_instance_profile | Whether to create an instance profile for EC2 | `bool` | `false` | no |
| tags | Additional tags to apply to the role | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| role_arn | The ARN of the IAM role |
| role_name | The name of the IAM role |
| role_id | The unique ID of the IAM role |
| role_create_date | The creation date of the IAM role |
| instance_profile_arn | The ARN of the instance profile (if created) |
| instance_profile_name | The name of the instance profile (if created) |
| instance_profile_id | The ID of the instance profile (if created) |