# ------------------------------------------------------------------------------
# AI Application Observability System Infrastructure
#
# This file contains the core infrastructure resources for building
# an observability system for AI applications at low cost using ARMS monitoring.
# ------------------------------------------------------------------------------

# Data source to get current region
data "alicloud_regions" "current" {
  current = true
}

# Define local variables for naming and computed values
locals {
  # Default deployment script for AI application with ARMS monitoring
  default_deployment_script = <<-EOF
    #!/bin/bash
    export ARMS_APP_NAME=${var.arms_config.app_name}
    export ARMS_REGION_ID=${data.alicloud_regions.current.regions[0].region_id}
    export ARMS_IS_PUBLIC=${var.arms_config.is_public}
    export ARMS_LICENSE_KEY=${var.arms_config.license_key}
    export DASHSCOPE_API_KEY=${var.bai_lian_config.api_key}

    curl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/ai-observable/install.sh | bash
  EOF
}

# Create a VPC for network isolation
resource "alicloud_vpc" "vpc" {
  cidr_block = var.vpc_config.cidr_block
  vpc_name   = var.vpc_config.vpc_name
}

# Create a VSwitch within the VPC
resource "alicloud_vswitch" "vswitch" {
  vpc_id       = alicloud_vpc.vpc.id
  cidr_block   = var.vswitch_config.cidr_block
  zone_id      = var.vswitch_config.zone_id
  vswitch_name = var.vswitch_config.vswitch_name
}

# Create a security group for network access control
resource "alicloud_security_group" "security_group" {
  vpc_id              = alicloud_vpc.vpc.id
  security_group_name = var.security_group_config.security_group_name
  description         = var.security_group_config.description
}

# Create security group rules to allow access to the application ports
resource "alicloud_security_group_rule" "allow_app_ports" {
  for_each          = { for i, rule in var.security_group_rule_configs : "${rule.type}-${i}" => rule }
  type              = each.value.type
  ip_protocol       = each.value.ip_protocol
  nic_type          = each.value.nic_type
  policy            = each.value.policy
  port_range        = each.value.port_range
  priority          = each.value.priority
  security_group_id = alicloud_security_group.security_group.id
  cidr_ip           = each.value.cidr_ip
}

# Create ECS instance for hosting the AI application
resource "alicloud_instance" "ecs_instance" {
  instance_name              = var.instance_config.instance_name
  image_id                   = var.instance_config.image_id
  instance_type              = var.instance_config.instance_type
  system_disk_category       = var.instance_config.system_disk_category
  security_groups            = [alicloud_security_group.security_group.id]
  vswitch_id                 = alicloud_vswitch.vswitch.id
  password                   = var.instance_config.password
  internet_max_bandwidth_out = var.instance_config.internet_max_bandwidth_out
}

# Create ECS command for deploying the AI application with monitoring
resource "alicloud_ecs_command" "run_command" {
  count = var.enable_ecs_invocation ? 1 : 0

  name            = var.ecs_command_config.name
  command_content = base64encode(var.custom_deployment_script != null ? var.custom_deployment_script : local.default_deployment_script)
  working_dir     = var.ecs_command_config.working_dir
  type            = var.ecs_command_config.type
  timeout         = var.ecs_command_config.timeout
}

# Execute the deployment command on the ECS instance
resource "alicloud_ecs_invocation" "invoke_script" {
  count = var.enable_ecs_invocation ? 1 : 0

  instance_id = [alicloud_instance.ecs_instance.id]
  command_id  = alicloud_ecs_command.run_command[0].id
  timeouts {
    create = var.ecs_invocation_config.create_timeout
  }
}