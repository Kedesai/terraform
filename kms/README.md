# KMS Module

This module creates a KMS key with configurable options for encryption, key rotation, aliases, and key policies.

## Features

- Symmetric and asymmetric key support
- Automatic key rotation
- Key aliases
- Configurable key policies
- Multi-region key support
- Key administrators and users management

## Usage

### Basic KMS Key

```hcl
module "kms" {
  source = "git::https://github.com/<your-username>/Terraform.git//kms?ref=v1.0.0"

  key_name    = "my-key"
  environment = "production"

  key_administrators = ["arn:aws:iam::123456789012:role/AdminRole"]
  key_users          = ["arn:aws:iam::123456789012:role/AppRole"]

  aliases = ["my-app-key"]

  tags = {
    Application = "my-app"
  }
}
```

### KMS Key with Custom Policy

```hcl
module "kms_custom" {
  source = "git::https://github.com/<your-username>/Terraform.git//kms?ref=v1.0.0"

  key_name                = "my-custom-key"
  environment             = "production"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  key_policy = jsonencode({
    Version = "2012-10-17"
    Id      = "custom-policy"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  aliases = ["my-custom-key", "app-encryption-key"]
}
```

### Asymmetric KMS Key for Sign/Verify

```hcl
module "kms_signing" {
  source = "git::https://github.com/<your-username>/Terraform.git//kms?ref=v1.0.0"

  key_name                 = "my-signing-key"
  environment              = "production"
  key_usage                = "SIGN_VERIFY"
  customer_master_key_spec = "ECC_NIST_P256"

  key_administrators = ["arn:aws:iam::123456789012:role/AdminRole"]
  key_users          = ["arn:aws:iam::123456789012:role/SigningServiceRole"]

  enable_key_rotation = false
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
| key_name | Name of the KMS key | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| description | Description of the KMS key | `string` | `""` | no |
| key_usage | Key usage (ENCRYPT_DECRYPT or SIGN_VERIFY) | `string` | `"ENCRYPT_DECRYPT"` | no |
| customer_master_key_spec | Key spec (SYMMETRIC_DEFAULT, RSA_2048, etc.) | `string` | `"SYMMETRIC_DEFAULT"` | no |
| deletion_window_in_days | Deletion window in days (7-30) | `number` | `30` | no |
| enable_key_rotation | Whether to enable automatic key rotation | `bool` | `true` | no |
| multi_region | Whether the key is multi-region | `bool` | `false` | no |
| key_policy | Key policy document (JSON string) | `string` | `null` | no |
| key_administrators | List of IAM ARNs for administrators | `list(string)` | `[]` | no |
| key_users | List of IAM ARNs for users | `list(string)` | `[]` | no |
| key_grantees | List of IAM ARNs for grantees | `list(string)` | `[]` | no |
| aliases | List of aliases for the KMS key | `list(string)` | `[]` | no |
| tags | Additional tags to apply to the key | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| key_id | The ID of the KMS key |
| key_arn | The ARN of the KMS key |
| key_alias_arns | List of KMS alias ARNs |
| key_alias_names | List of KMS alias names |