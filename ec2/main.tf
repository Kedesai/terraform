# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# EC2 Instance
resource "aws_instance" "this" {
  ami                         = var.ami_id != null ? var.ami_id : data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.monitoring_enabled
  user_data                   = var.user_data

  disable_api_termination = var.enable_termination_protection

  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior

  metadata_options {
    http_tokens                 = var.metadata_http_tokens
    http_endpoint               = var.metadata_http_endpoint_enabled ? "enabled" : "disabled"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size              = var.root_volume_size
    volume_type              = var.root_volume_type
    encrypted                = var.root_volume_encrypted
    kms_key_id               = var.root_volume_kms_key_id
    delete_on_termination    = true
    tags = merge(
      {
        Name = "${var.instance_name}-root"
      },
      var.tags
    )
  }

  dynamic "ebs_block_device" {
    for_each = var.additional_ebs_volumes

    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
      encrypted             = ebs_block_device.value.encrypted
      kms_key_id            = ebs_block_device.value.kms_key_id
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  tags = merge(
    {
      Name        = var.instance_name
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )
}