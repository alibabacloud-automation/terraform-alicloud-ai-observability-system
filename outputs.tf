# ------------------------------------------------------------------------------
# Module Outputs
#
# This file defines the outputs of the AI Application Observability System module.
# These outputs provide important resource information that can be used by other
# modules or for reference after deployment.
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the VPC"
  value       = alicloud_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = alicloud_vpc.vpc.cidr_block
}

output "vswitch_id" {
  description = "The ID of the VSwitch"
  value       = alicloud_vswitch.vswitch.id
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = alicloud_security_group.security_group.id
}

output "ram_user_name" {
  description = "The name of the RAM user"
  value       = alicloud_ram_user.ram_user.name
}

output "ram_access_key_id" {
  description = "The access key ID of the RAM user"
  value       = alicloud_ram_access_key.ram_access_key.id
}

output "ram_access_key_secret" {
  description = "The access key secret of the RAM user"
  value       = alicloud_ram_access_key.ram_access_key.secret
  sensitive   = true
}

output "instance_id" {
  description = "The ID of the ECS instance"
  value       = alicloud_instance.ecs_instance.id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = alicloud_instance.ecs_instance.primary_ip_address
}

output "ecs_command_id" {
  description = "The ID of the ECS command for AI application deployment"
  value       = var.enable_ecs_invocation ? alicloud_ecs_command.run_command[0].id : null
}

output "ecs_invocation_id" {
  description = "The ID of the ECS command invocation"
  value       = var.enable_ecs_invocation ? alicloud_ecs_invocation.invoke_script[0].id : null
}

output "region" {
  description = "The region where resources are deployed"
  value       = data.alicloud_regions.current.regions[0].region_id
}

output "ecs_login_address" {
  description = "The ECS workbench login address for the deployed instance"
  value       = format("https://ecs-workbench.aliyun.com/?from=ecs&instanceType=ecs&regionId=%s&instanceId=%s&resourceGroupId=", data.alicloud_regions.current.regions[0].region_id, alicloud_instance.ecs_instance.id)
}

output "application_access_info" {
  description = "Information for accessing the deployed AI application"
  value = {
    public_ip         = alicloud_instance.ecs_instance.public_ip
    private_ip        = alicloud_instance.ecs_instance.primary_ip_address
    port              = "8000"
    docs_url          = "http://${alicloud_instance.ecs_instance.public_ip}:8000/docs"
    api_endpoint      = "http://${alicloud_instance.ecs_instance.public_ip}:8000/agent/invoke"
    note              = "To access from public internet, ensure security group allows access from 0.0.0.0/0"
    deployment_status = var.enable_ecs_invocation ? "Automatic deployment enabled" : "Manual deployment required"
  }
}