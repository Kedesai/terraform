# Lambda Module

This module creates a Lambda function with configurable options for runtime, memory, timeout, VPC configuration, and event source mappings.

## Features

- Lambda function with configurable runtime and resources
- Support for deployment via filename or S3
- VPC configuration for private network access
- Dead Letter Queue (DLQ) support
- Environment variables with KMS encryption
- X-Ray tracing support
- Lambda Layers support
- Ephemeral storage configuration
- SnapStart for Java functions
- Automatic CloudWatch log group creation

## Usage

### Basic Lambda Function

```hcl
module "lambda" {
  source = "git::https://github.com/<your-username>/Terraform.git//lambda?ref=v1.0.0"

  function_name = "my-function"
  environment   = "production"
  runtime       = "python3.11"
  handler       = "index.lambda_handler"
  filename      = "lambda.zip"
  role_arn      = "arn:aws:iam::123456789012:role/lambda-execution-role"

  memory_size = 256
  timeout     = 30

  environment_variables = {
    LOG_LEVEL = "INFO"
    ENV       = "production"
  }

  tags = {
    Application = "my-app"
  }
}
```

### Lambda with VPC and DLQ

```hcl
module "lambda_vpc" {
  source = "git::https://github.com/<your-username>/Terraform.git//lambda?ref=v1.0.0"

  function_name = "my-vpc-function"
  environment   = "production"
  runtime       = "nodejs20.x"
  handler       = "index.handler"
  s3_bucket     = "my-deployment-bucket"
  s3_key        = "lambda/function.zip"
  role_arn      = "arn:aws:iam::123456789012:role/lambda-execution-role"

  memory_size = 512
  timeout     = 60

  vpc_subnet_ids         = ["subnet-12345678", "subnet-87654321"]
  vpc_security_group_ids = ["sg-12345678"]

  dead_letter_target_arn = "arn:aws:sqs:us-east-1:123456789012:my-dlq"

  tracing_config_mode = "Active"

  layers = ["arn:aws:lambda:us-east-1:123456789012:layer:my-layer:1"]
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
| function_name | Name of the Lambda function | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| runtime | Lambda runtime (e.g., python3.11, nodejs20.x) | `string` | n/a | yes |
| handler | Lambda handler function | `string` | n/a | yes |
| filename | Path to the deployment package | `string` | `null` | no |
| s3_bucket | S3 bucket containing the deployment package | `string` | `null` | no |
| s3_key | S3 key of the deployment package | `string` | `null` | no |
| s3_object_version | S3 object version of the deployment package | `string` | `null` | no |
| source_code_hash | Hash of the source code for tracking changes | `string` | `null` | no |
| memory_size | Memory size in MB | `number` | `128` | no |
| timeout | Function timeout in seconds | `number` | `3` | no |
| role_arn | IAM role ARN for the Lambda function | `string` | n/a | yes |
| description | Function description | `string` | `""` | no |
| environment_variables | Environment variables for the function | `map(string)` | `{}` | no |
| kms_key_arn | KMS key ARN for encrypting environment variables | `string` | `null` | no |
| tracing_config_mode | Tracing mode (PassThrough or Active) | `string` | `null` | no |
| vpc_subnet_ids | List of VPC subnet IDs | `list(string)` | `[]` | no |
| vpc_security_group_ids | List of VPC security group IDs | `list(string)` | `[]` | no |
| dead_letter_target_arn | ARN of the DLQ (SQS or SNS) | `string` | `null` | no |
| reserved_concurrent_executions | Number of reserved concurrent executions | `number` | `null` | no |
| publish | Whether to publish a version | `bool` | `false` | no |
| layers | List of Lambda layer ARNs | `list(string)` | `[]` | no |
| ephemeral_storage_size | Ephemeral storage size in MB (512-10240) | `number` | `512` | no |
| snap_start | SnapStart configuration | `object` | `null` | no |
| tags | Additional tags to apply to the function | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_arn | The ARN of the Lambda function |
| function_name | The name of the Lambda function |
| function_qualified_arn | The ARN including the version (if published) |
| function_invoke_arn | The ARN to use for invoking the function |
| function_id | The ID of the Lambda function |
| cloudwatch_log_group_arn | The ARN of the CloudWatch log group |
| cloudwatch_log_group_name | The name of the CloudWatch log group |