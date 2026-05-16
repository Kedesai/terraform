# SQS Module

This module creates an SQS queue with configurable options for FIFO, encryption, dead-letter queues, and message retention.

## Features

- Standard or FIFO queue support
- Server-side encryption with KMS
- Dead-letter queue (DLQ) support
- Configurable message retention
- Visibility timeout configuration
- Long polling support
- Queue policies

## Usage

### Basic SQS Queue

```hcl
module "sqs" {
  source = "git::https://github.com/<your-username>/Terraform.git//sqs?ref=v1.0.0"

  queue_name   = "my-queue"
  environment  = "production"
}
```

### SQS Queue with DLQ

```hcl
# Dead Letter Queue
module "sqs_dlq" {
  source = "git::https://github.com/<your-username>/Terraform.git//sqs?ref=v1.0.0"

  queue_name   = "my-dlq"
  environment  = "production"
}

# Main Queue with DLQ
module "sqs_main" {
  source = "git::https://github.com/<your-username>/Terraform.git//sqs?ref=v1.0.0"

  queue_name   = "my-main-queue"
  environment  = "production"

  redrive_policy_dead_letter_target_arn = module.sqs_dlq.queue_arn
  redrive_policy_max_receive_count      = 5

  visibility_timeout_seconds = 60
  message_retention_seconds  = 604800

  kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"
}
```

### FIFO Queue

```hcl
module "sqs_fifo" {
  source = "git::https://github.com/<your-username>/Terraform.git//sqs?ref=v1.0.0"

  queue_name                  = "my-fifo-queue.fifo"
  environment                 = "production"
  fifo_queue                  = true
  content_based_deduplication = true

  tags = {
    Type = "FIFO"
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
| queue_name | Name of the SQS queue | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| fifo_queue | Whether to create a FIFO queue | `bool` | `false` | no |
| content_based_deduplication | Enable content-based deduplication | `bool` | `false` | no |
| delay_seconds | Default delay for messages (0-900) | `number` | `0` | no |
| max_message_size | Maximum message size in bytes | `number` | `262144` | no |
| message_retention_seconds | Message retention period in seconds | `number` | `345600` | no |
| receive_wait_time_seconds | Time to wait for messages (0-20) | `number` | `0` | no |
| visibility_timeout_seconds | Visibility timeout in seconds | `number` | `30` | no |
| kms_master_key_id | KMS key ID for encryption | `string` | `null` | no |
| kms_data_key_reuse_period_seconds | Time to reuse the data key | `number` | `300` | no |
| redrive_policy_dead_letter_target_arn | ARN of the dead-letter queue | `string` | `null` | no |
| redrive_policy_max_receive_count | Max receive count before DLQ | `number` | `null` | no |
| policy | SQS queue policy (JSON string) | `string` | `null` | no |
| tags | Additional tags to apply to the queue | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| queue_id | The ID of the SQS queue |
| queue_arn | The ARN of the SQS queue |
| queue_name | The name of the SQS queue |
| queue_url | The URL of the SQS queue |