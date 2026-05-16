# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = var.function_name
  runtime       = var.runtime
  handler       = var.handler
  description   = var.description

  # Source code - either filename or S3
  filename         = var.filename
  source_code_hash = var.source_code_hash

  s3_bucket         = var.s3_bucket
  s3_key            = var.s3_key
  s3_object_version = var.s3_object_version

  memory_size  = var.memory_size
  timeout      = var.timeout
  role         = var.role_arn
  publish      = var.publish
  layers       = length(var.layers) > 0 ? var.layers : null

  kms_key_arn = var.kms_key_arn

  environment {
    variables = var.environment_variables
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config_mode != null ? [var.tracing_config_mode] : []
    content {
      mode = tracing_config.value
    }
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  dynamic "dead_letter_config" {
    for_each = var.dead_letter_target_arn != null ? [1] : []
    content {
      target_arn = var.dead_letter_target_arn
    }
  }

  reserved_concurrent_executions = var.reserved_concurrent_executions

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage_size != 512 ? [1] : []
    content {
      size = var.ephemeral_storage_size
    }
  }

  dynamic "snap_start" {
    for_each = var.snap_start != null ? [var.snap_start] : []
    content {
      apply_on = snap_start.value.apply_on
    }
  }

  tags = merge(
    {
      Name        = var.function_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 30

  tags = merge(
    {
      Name        = "${var.function_name}-logs"
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}