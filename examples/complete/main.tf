# ------------------------------------------------------------------------------
# Complete Example for AI Application Observability System
#
# This example demonstrates how to use the AI Application Observability System
# module to deploy a complete AI application with ARMS monitoring.
# ------------------------------------------------------------------------------

# Configure Alibaba Cloud Provider
provider "alicloud" {
  region = var.region
}

# Generate random suffix for unique resource naming
resource "random_string" "suffix" {
  length  = 8
  lower   = true
  upper   = false
  numeric = false
  special = false
}

# Query available zones for the specified instance type
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = var.instance_type
}

# Query available Ubuntu images
data "alicloud_images" "default" {
  name_regex  = "^ubuntu_24_04_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

# Deploy the AI Application Observability System module
module "ai_observability_system" {
  source = "../../"

  vpc_config = {
    cidr_block = var.vpc_cidr_block
    vpc_name   = var.vpc_name
  }

  vswitch_config = {
    cidr_block   = var.vswitch_cidr_block
    zone_id      = data.alicloud_zones.default.zones[0].id
    vswitch_name = var.vswitch_name
  }

  security_group_config = {
    security_group_name = var.security_group_name
    description         = var.security_group_description
  }

  security_group_rule_config = {
    type        = "ingress"
    ip_protocol = "tcp"
    nic_type    = "intranet"
    policy      = "accept"
    port_range  = "8000/8000"
    priority    = 1
    cidr_ip     = var.allow_public_access ? "0.0.0.0/0" : var.vswitch_cidr_block
  }

  instance_config = {
    image_id                   = data.alicloud_images.default.images[0].id
    instance_type              = var.instance_type
    system_disk_category       = var.system_disk_category
    password                   = var.ecs_instance_password
    instance_name              = var.ecs_instance_name
    internet_max_bandwidth_out = var.internet_max_bandwidth_out
  }

  arms_config = {
    app_name    = var.arms_app_name
    is_public   = var.arms_is_public
    license_key = var.arms_license_key
  }

  ram_user_config = {
    name = "tf-module-user-${random_string.suffix.id}"
  }

  bai_lian_config = {
    api_key = var.bai_lian_api_key
  }

  enable_ecs_invocation = var.enable_ecs_invocation
}