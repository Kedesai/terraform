# DynamoDB Table
resource "aws_dynamodb_table" "this" {
  name           = var.table_name
  billing_mode   = var.billing_mode
  hash_key       = var.hash_key
  range_key      = var.range_key

  dynamic "attribute" {
    for_each = concat(
      [
        {
          name = var.hash_key
          type = var.hash_key_type
        }
      ],
      var.range_key != null ? [
        {
          name = var.range_key
          type = var.range_key_type
        }
      ] : [],
      var.attributes
    )
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name            = local_secondary_index.value.name
      range_key       = local_secondary_index.value.range_key
      projection_type = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.non_key_attributes
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name            = global_secondary_index.value.name
      hash_key        = global_secondary_index.value.hash_key
      range_key       = global_secondary_index.value.range_key
      projection_type = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes

      # Only set capacity for PROVISIONED billing mode
      write_capacity = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.write_capacity : null
      read_capacity  = var.billing_mode == "PROVISIONED" ? global_secondary_index.value.read_capacity : null
    }
  }

  # Capacity for PROVISIONED billing mode
  read_capacity  = var.billing_mode == "PROVISIONED" ? var.read_capacity : null
  write_capacity = var.billing_mode == "PROVISIONED" ? var.write_capacity : null

  point_in_time_recovery {
    enabled = var.point_in_time_recovery
  }

  dynamic "ttl" {
    for_each = var.ttl_attribute != null ? [var.ttl_attribute] : []
    content {
      attribute_name = ttl.value
      enabled        = true
    }
  }

  dynamic "stream" {
    for_each = var.stream_enabled ? ["enabled"] : []
    content {
      enabled      = true
      view_type    = var.stream_view_type
    }
  }

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption_kms_key_arn != null ? [1] : []
    content {
      enabled     = true
      kms_key_arn = var.server_side_encryption_kms_key_arn
    }
  }

  deletion_protection_enabled = var.deletion_protection_enabled

  tags = merge(
    {
      Name        = var.table_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}