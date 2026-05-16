# RDS Module

This module creates an RDS database instance with configurable options for engine, instance class, storage, backup, and monitoring.

## Features

- Support for multiple database engines (MySQL, PostgreSQL, MariaDB, Oracle, SQL Server)
- Multi-AZ deployment support
- Automated backups with configurable retention
- Performance Insights
- CloudWatch Logs exports
- Storage autoscaling
- Encryption at rest with KMS
- Deletion protection

## Usage

### Basic PostgreSQL Instance

```hcl
module "rds" {
  source = "git::https://github.com/<your-username>/Terraform.git//rds?ref=v1.0.0"

  db_instance_identifier = "my-database"
  environment            = "production"
  engine                 = "postgres"
  engine_version         = "15.4"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  username               = "admin"
  password               = "secure-password"
  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-db-subnet-group"
}
```

### Production MySQL Instance with Multi-AZ

```hcl
module "rds_mysql" {
  source = "git::https://github.com/<your-username>/Terraform.git//rds?ref=v1.0.0"

  db_instance_identifier = "my-mysql-db"
  environment            = "production"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.r5.large"
  allocated_storage      = 100
  max_allocated_storage  = 500
  storage_type           = "gp3"
  multi_az               = true

  username               = "admin"
  password               = "secure-password"
  db_name                = "myapp"

  vpc_security_group_ids = ["sg-12345678"]
  db_subnet_group_name   = "my-db-subnet-group"

  backup_retention_period        = 14
  performance_insights_enabled   = true
  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  deletion_protection = true
  skip_final_snapshot = false
  final_snapshot_identifier = "my-mysql-db-final-snapshot"

  tags = {
    Application = "my-app"
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
| db_instance_identifier | Name of the RDS instance | `string` | n/a | yes |
| environment | Environment name | `string` | n/a | yes |
| engine | Database engine | `string` | n/a | yes |
| engine_version | Database engine version | `string` | n/a | yes |
| instance_class | Database instance class | `string` | n/a | yes |
| allocated_storage | Allocated storage in GB | `number` | n/a | yes |
| max_allocated_storage | Maximum allocated storage for autoscaling | `number` | `0` | no |
| storage_type | Storage type (gp2, gp3, io1, io2, standard) | `string` | `"gp2"` | no |
| iops | IOPS for io1/io2 storage types | `number` | `null` | no |
| db_name | Name of the database | `string` | `null` | no |
| username | Master username | `string` | n/a | yes |
| password | Master password | `string` | n/a | yes |
| port | Database port | `number` | `null` | no |
| vpc_security_group_ids | List of security group IDs | `list(string)` | `[]` | no |
| db_subnet_group_name | DB subnet group name | `string` | `null` | no |
| multi_az | Whether to enable Multi-AZ deployment | `bool` | `false` | no |
| backup_retention_period | Number of days to retain backups | `number` | `7` | no |
| backup_window | Preferred backup window | `string` | `"03:00-04:00"` | no |
| maintenance_window | Preferred maintenance window | `string` | `"Mon:04:00-Mon:05:00"` | no |
| skip_final_snapshot | Whether to skip final snapshot when deleting | `bool` | `false` | no |
| final_snapshot_identifier | Final snapshot identifier | `string` | `null` | no |
| deletion_protection | Whether to enable deletion protection | `bool` | `true` | no |
| performance_insights_enabled | Whether to enable Performance Insights | `bool` | `false` | no |
| performance_insights_retention_period | Performance Insights retention period in days | `number` | `7` | no |
| enabled_cloudwatch_logs_exports | List of log types to export to CloudWatch Logs | `list(string)` | `[]` | no |
| auto_minor_version_upgrade | Whether to enable auto minor version upgrades | `bool` | `true` | no |
| publicly_accessible | Whether the instance is publicly accessible | `bool` | `false` | no |
| apply_immediately | Whether to apply changes immediately | `bool` | `false` | no |
| kms_key_id | KMS key ID for encryption | `string` | `null` | no |
| tags | Additional tags to apply to the instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_id | The ID of the RDS instance |
| db_instance_arn | The ARN of the RDS instance |
| db_instance_endpoint | The connection endpoint |
| db_instance_address | The hostname of the RDS instance |
| db_instance_port | The database port |
| db_instance_name | The database name |
| db_instance_username | The master username |
| db_instance_resource_id | The RDS resource ID |
| db_instance_availability_zone | The availability zone of the instance |