# DynamoDB Module

This module creates a DynamoDB table with configurable options for billing mode, keys, indexes, TTL, streams, and encryption.

## Features

- DynamoDB table with on-demand or provisioned capacity
- Partition key and sort key configuration
- Global and local secondary indexes
- Time-to-live (TTL) support
- DynamoDB Streams
- Point-in-time recovery
- Server-side encryption with KMS
- Deletion protection

## Usage

### Basic Table with On-Demand Billing

```hcl
module "dynamodb" {
  source = "git::https://github.com/<your-username>/Terraform.git//dynamodb?ref=v1.0.0"

  table_name   = "my-table"
  environment  = "production"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"
  hash_key_type = "S"
}
```

### Table with Sort Key and GSI

```hcl
module "dynamodb_gsi" {
  source = "git::https://github.com/<your-username>/Terraform.git//dynamodb?ref=v1.0.0"

  table_name   = "my-composite-table"
  environment  = "production"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pk"
  range_key    = "sk"
  hash_key_type = "S"
  range_key_type = "S"

  attributes = [
    {
      name = "GSI1PK"
      type = "S"
    },
    {
      name = "GSI1SK"
      type = "S"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "GSI1"
      hash_key        = "GSI1PK"
      range_key       = "GSI1SK"
      projection_type = "ALL"
    }
  ]

  point_in_time_recovery = true
  stream_enabled         = true
  stream_view_type       = "NEW_AND_OLD_IMAGES"

  tags = {
    Application = "my-app"
  }
}
```

### Table with TTL and Provisioned Capacity

```hcl
module "dynamodb_ttl" {
  source = "git::https://github.com/<your-username>/Terraform.git//dynamodb?ref=v1.0.0"

  table_name   = "my-session-table"
  environment  = "production"
  billing_mode = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key     = "session_id"
  ttl_attribute = "expires_at"

  tags = {
    Purpose = "session-store"
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
| table_name | Name of the DynamoDB table | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| billing_mode | Billing mode (PAY_PER_REQUEST or PROVISIONED) | `string` | `"PAY_PER_REQUEST"` | no |
| read_capacity | Read capacity units (for PROVISIONED mode) | `number` | `null` | no |
| write_capacity | Write capacity units (for PROVISIONED mode) | `number` | `null` | no |
| hash_key | Name of the hash key (partition key) | `string` | n/a | yes |
| range_key | Name of the range key (sort key) | `string` | `null` | no |
| hash_key_type | Type of the hash key (S, N, or B) | `string` | `"S"` | no |
| range_key_type | Type of the range key (S, N, or B) | `string` | `"S"` | no |
| attributes | Additional attribute definitions for indexes | `list(object)` | `[]` | no |
| global_secondary_indexes | List of global secondary indexes | `list(object)` | `[]` | no |
| local_secondary_indexes | List of local secondary indexes | `list(object)` | `[]` | no |
| point_in_time_recovery | Whether to enable point-in-time recovery | `bool` | `false` | no |
| ttl_attribute | Attribute name for TTL | `string` | `null` | no |
| stream_enabled | Whether to enable DynamoDB Streams | `bool` | `false` | no |
| stream_view_type | Stream view type | `string` | `"NEW_AND_OLD_IMAGES"` | no |
| server_side_encryption_kms_key_arn | KMS key ARN for encryption | `string` | `null` | no |
| deletion_protection_enabled | Whether to enable deletion protection | `bool` | `false` | no |
| tags | Additional tags to apply to the table | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| table_id | The ID of the DynamoDB table |
| table_arn | The ARN of the DynamoDB table |
| table_name | The name of the DynamoDB table |
| table_stream_arn | The ARN of the DynamoDB Stream (if enabled) |
| table_stream_label | The timestamp of the DynamoDB Stream creation |