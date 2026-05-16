# S3 Module

This module creates an S3 bucket with configurable options for versioning, encryption, lifecycle policies, access logging, CORS, and static website hosting.

## Features

- S3 bucket with configurable name
- Versioning support
- Server-side encryption (AES256 or KMS)
- Block public access settings
- Lifecycle rules for storage tiering and expiration
- Access logging
- CORS configuration
- Static website hosting support
- Automatic non-current version management

## Usage

### Basic Bucket

```hcl
module "s3" {
  source = "git::https://github.com/<your-username>/Terraform.git//s3?ref=v1.0.0"

  bucket_name = "my-application-bucket"
  environment = "production"
}
```

### Bucket with Website Hosting

```hcl
module "s3_website" {
  source = "git::https://github.com/<your-username>/Terraform.git//s3?ref=v1.0.0"

  bucket_name = "my-website-bucket"
  environment = "production"

  website_configuration = {
    index_document = "index.html"
    error_document = "error.html"
  }
}
```

### Bucket with Lifecycle Rules

```hcl
module "s3_with_lifecycle" {
  source = "git::https://github.com/<your-username>/Terraform.git//s3?ref=v1.0.0"

  bucket_name            = "my-data-bucket"
  environment            = "production"
  enable_lifecycle_rules = true
  lifecycle_transition_days = 30
  lifecycle_glacier_days    = 90
  lifecycle_expiration_days = 365
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
| bucket_name | Name of the S3 bucket | `string` | n/a | yes |
| environment | Environment name (e.g., dev, staging, production) | `string` | n/a | yes |
| acl | Canned ACL for the bucket (deprecated) | `string` | `null` | no |
| versioning_enabled | Whether to enable versioning on the bucket | `bool` | `true` | no |
| enable_encryption | Whether to enable server-side encryption | `bool` | `true` | no |
| sse_algorithm | Server-side encryption algorithm (AES256 or aws:kms) | `string` | `"AES256"` | no |
| kms_master_key_arn | KMS master key ARN for encryption | `string` | `null` | no |
| block_public_acls | Whether to block public ACLs | `bool` | `true` | no |
| block_public_policy | Whether to block public bucket policies | `bool` | `true` | no |
| ignore_public_acls | Whether to ignore public ACLs | `bool` | `true` | no |
| restrict_public_buckets | Whether to restrict public bucket policies | `bool` | `true` | no |
| enable_lifecycle_rules | Whether to enable lifecycle rules | `bool` | `false` | no |
| lifecycle_transition_days | Days until transition to Standard-IA | `number` | `30` | no |
| lifecycle_glacier_days | Days until transition to Glacier | `number` | `90` | no |
| lifecycle_expiration_days | Days until object expiration | `number` | `365` | no |
| enable_access_logging | Whether to enable S3 access logging | `bool` | `false` | no |
| log_target_bucket | Target bucket for access logs | `string` | `null` | no |
| log_target_prefix | Prefix for log object keys | `string` | `"logs/"` | no |
| cors_configuration | CORS configuration for the bucket | `list(object)` | `null` | no |
| website_configuration | Website configuration for static hosting | `object` | `null` | no |
| force_destroy | Whether to force destroy the bucket | `bool` | `false` | no |
| tags | Additional tags to apply to the bucket | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_id | The ID of the S3 bucket |
| bucket_arn | The ARN of the S3 bucket |
| bucket_domain_name | The bucket domain name |
| bucket_regional_domain_name | The bucket region-specific domain name |
| bucket_hosted_zone_id | The Route 53 Hosted Zone ID for the bucket |
| website_endpoint | The website endpoint (if website hosting is enabled) |
| website_domain | The domain of the website endpoint |