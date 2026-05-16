# SNS Module

This module creates an SNS topic with configurable options for encryption, FIFO, delivery policies, and subscriptions.

## Features

- SNS topic with standard or FIFO type
- Server-side encryption with KMS
- Multiple subscription protocols (SQS, Lambda, HTTP/S, Email, SMS)
- Delivery policies
- Filter policies for subscriptions
- Success feedback configuration

## Usage

### Basic SNS Topic

```hcl
module "sns" {
  source = "git::https://github.com/<your-username>/Terraform.git//sns?ref=v1.0.0"

  topic_name   = "my-topic"
  environment  = "production"
  display_name = "My Application Notifications"
}
```

### SNS Topic with SQS Subscription

```hcl
module "sns_sqs" {
  source = "git::https://github.com/<your-username>/Terraform.git//sns?ref=v1.0.0"

  topic_name   = "my-notifications"
  environment  = "production"
  display_name = "Application Notifications"

  subscriptions = [
    {
      protocol = "sqs"
      endpoint = "arn:aws:sqs:us-east-1:123456789012:my-queue"
    }
  ]

  tags = {
    Application = "my-app"
  }
}
```

### SNS Topic with Multiple Subscriptions

```hcl
module "sns_multi" {
  source = "git::https://github.com/<your-username>/Terraform.git//sns?ref=v1.0.0"

  topic_name   = "my-alerts"
  environment  = "production"
  display_name = "System Alerts"

  kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/12345678-1234-1234-1234-123456789012"

  subscriptions = [
    {
      protocol = "sqs"
      endpoint = "arn:aws:sqs:us-east-1:123456789012:my-queue"
    },
    {
      protocol = "lambda"
      endpoint = "arn:aws:lambda:us-east-1:123456789012:function:my-function"
    },
    {
      protocol = "email"
      endpoint = "user@example.com"
    }
  ]
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
| topic_name | Name of the SNS topic | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| display_name | Display name for the SNS topic | `string` | `null` | no |
| kms_master_key_id | KMS key ID for server-side encryption | `string` | `null` | no |
| fifo_topic | Whether to create a FIFO topic | `bool` | `false` | no |
| content_based_deduplication | Enable content-based deduplication | `bool` | `false` | no |
| delivery_policy | Delivery policy for the SNS topic | `string` | `null` | no |
| application_success_feedback_role_arn | IAM role ARN for application success feedback | `string` | `null` | no |
| application_success_feedback_sample_rate | Sample rate for application success feedback | `number` | `null` | no |
| http_success_feedback_role_arn | IAM role ARN for HTTP success feedback | `string` | `null` | no |
| http_success_feedback_sample_rate | Sample rate for HTTP success feedback | `number` | `null` | no |
| lambda_success_feedback_role_arn | IAM role ARN for Lambda success feedback | `string` | `null` | no |
| lambda_success_feedback_sample_rate | Sample rate for Lambda success feedback | `number` | `null` | no |
| sqs_success_feedback_role_arn | IAM role ARN for SQS success feedback | `string` | `null` | no |
| sqs_success_feedback_sample_rate | Sample rate for SQS success feedback | `number` | `null` | no |
| subscriptions | List of subscriptions to create | `list(object)` | `[]` | no |
| tags | Additional tags to apply to the topic | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| topic_arn | The ARN of the SNS topic |
| topic_name | The name of the SNS topic |
| topic_id | The ID of the SNS topic |
| topic_owner | The AWS account ID of the SNS topic owner |
| subscription_arns | List of subscription ARNs |