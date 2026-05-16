# RDS Instance
resource "aws_db_instance" "this" {
  identifier        = var.db_instance_identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  storage_type      = var.storage_type
  iops              = var.iops
  max_allocated_storage = var.max_allocated_storage > 0 ? var.max_allocated_storage : null

  db_name  = var.db_name
  username = var.username
  password = var.password
  port     = var.port

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name

  multi_az               = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  deletion_protection       = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  publicly_accessible             = var.publicly_accessible
  apply_immediately               = var.apply_immediately

  storage_encrypted = var.kms_key_id != null ? true : false
  kms_key_id        = var.kms_key_id

  tags = merge(
    {
      Name        = var.db_instance_identifier
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}