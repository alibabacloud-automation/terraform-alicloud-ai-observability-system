# ------------------------------------------------------------------------------
# Outputs for Complete Example
#
# This file defines outputs for the complete example, exposing important
# information from the deployed AI Application Observability System.
# ------------------------------------------------------------------------------

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = module.ai_observability_system.vpc_id
}

output "instance_id" {
  description = "The ID of the ECS instance"
  value       = module.ai_observability_system.instance_id
}

output "instance_public_ip" {
  description = "The public IP address of the ECS instance"
  value       = module.ai_observability_system.instance_public_ip
}

output "instance_private_ip" {
  description = "The private IP address of the ECS instance"
  value       = module.ai_observability_system.instance_private_ip
}

output "ecs_login_address" {
  description = "ECS workbench login address for the deployed instance"
  value       = module.ai_observability_system.ecs_login_address
}

output "application_access_info" {
  description = "Information for accessing the deployed AI application"
  value       = module.ai_observability_system.application_access_info
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = module.ai_observability_system.security_group_id
}