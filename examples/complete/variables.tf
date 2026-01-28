# ------------------------------------------------------------------------------
# Variables for Complete Example
#
# This file defines variables used in the complete example of the
# AI Application Observability System module.
# ------------------------------------------------------------------------------

variable "region" {
  description = "The Alibaba Cloud region to deploy resources"
  type        = string
  default     = "cn-shanghai"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "192.168.0.0/16"
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = null
}

variable "vswitch_cidr_block" {
  description = "CIDR block for the VSwitch"
  type        = string
  default     = "192.168.0.0/24"
}

variable "vswitch_name" {
  description = "Name for the VSwitch"
  type        = string
  default     = null
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for AI application observability system"
}

variable "allow_public_access" {
  description = "Whether to allow public internet access to the application"
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "ECS instance type"
  type        = string
  default     = "ecs.t6-c1m2.large"
}

variable "system_disk_category" {
  description = "System disk category for ECS instance"
  type        = string
  default     = "cloud_essd"
}

variable "ecs_instance_password" {
  description = "Password for ECS instance login. Must be 8-30 characters and contain uppercase, lowercase, numbers, and special characters"
  type        = string
  sensitive   = true
}

variable "ecs_instance_name" {
  description = "Name for the ECS instance"
  type        = string
  default     = null
}

variable "internet_max_bandwidth_out" {
  description = "Maximum outbound internet bandwidth for ECS instance"
  type        = number
  default     = 5
}

variable "arms_app_name" {
  description = "ARMS application name for monitoring"
  type        = string
  default     = "llm_app"
}

variable "arms_is_public" {
  description = "Whether ARMS monitoring is public"
  type        = bool
  default     = true
}

variable "arms_license_key" {
  description = "ARMS license key for monitoring. Get from https://api.aliyun.com/api/ARMS/2019-08-08/DescribeTraceLicenseKey"
  type        = string
  sensitive   = true
}

variable "bai_lian_api_key" {
  description = "Bailian (DashScope) API key for AI model access. Get from https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key"
  type        = string
  sensitive   = true
}

variable "enable_ecs_invocation" {
  description = "Whether to enable ECS command invocation for AI application deployment. Set to false for testing to avoid timeout"
  type        = bool
  default     = false
}