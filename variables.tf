# ------------------------------------------------------------------------------
# Module Input Variables
#
# This file defines all configurable input variables for the AI Application
# Observability System module. Each variable includes detailed description,
# type definition, and default values where applicable.
# ------------------------------------------------------------------------------
variable "vpc_config" {
  description = "VPC configuration. The 'cidr_block' attribute is required"
  type = object({
    cidr_block = string
    vpc_name   = optional(string, null)
  })
  default = {
    cidr_block = "192.168.0.0/16"
    vpc_name   = null
  }
}

variable "vswitch_config" {
  description = "VSwitch configuration. The 'cidr_block' and 'zone_id' attributes are required"
  type = object({
    cidr_block   = string
    zone_id      = string
    vswitch_name = optional(string, null)
  })
  default = {
    cidr_block   = "192.168.0.0/24"
    zone_id      = null
    vswitch_name = null
  }
}

variable "security_group_config" {
  description = "Security group configuration"
  type = object({
    security_group_name = optional(string, null)
    description         = optional(string, "Security group for AI application observability system")
  })
  default = {
    security_group_name = null
    description         = "Security group for AI application observability system"
  }
}

variable "security_group_rule_config" {
  description = "Security group rule configuration for allowing access to application port"
  type = object({
    type        = string
    ip_protocol = string
    nic_type    = string
    policy      = string
    port_range  = string
    priority    = number
    cidr_ip     = string
  })
  default = {
    type        = "ingress"
    ip_protocol = "tcp"
    nic_type    = "intranet"
    policy      = "accept"
    port_range  = "8000/8000"
    priority    = 1
    cidr_ip     = "192.168.0.0/24"
  }
}

variable "ram_user_config" {
  description = "RAM user configuration for service access authorization"
  type = object({
    name = string
  })
}

variable "ram_policy_attachment_config" {
  description = "RAM policy attachment configuration"
  type = object({
    policy_type = string
    policy_name = string
  })
  default = {
    policy_type = "System"
    policy_name = "AliyunLogFullAccess"
  }
}

variable "instance_config" {
  description = "ECS instance configuration. The 'image_id', 'instance_type', 'system_disk_category', and 'password' attributes are required"
  type = object({
    image_id                   = string
    instance_type              = string
    system_disk_category       = string
    password                   = string
    instance_name              = optional(string, null)
    internet_max_bandwidth_out = optional(number, 5)
  })
  default = {
    image_id                   = null
    instance_type              = "ecs.t6-c1m2.large"
    system_disk_category       = "cloud_essd"
    password                   = null
    instance_name              = null
    internet_max_bandwidth_out = 5
  }
  sensitive = true
}

variable "arms_config" {
  description = "ARMS (Application Real-Time Monitoring Service) configuration"
  type = object({
    app_name    = string
    is_public   = bool
    license_key = string
  })
  default = {
    app_name    = "llm_app"
    is_public   = true
    license_key = null
  }
  sensitive = true
}

variable "bai_lian_config" {
  description = "Bailian (DashScope) API configuration"
  type = object({
    api_key = string
  })
  default = {
    api_key = null
  }
  sensitive = true
}

variable "ecs_command_config" {
  description = "ECS command configuration for deploying AI application"
  type = object({
    name        = optional(string, null)
    working_dir = string
    type        = string
    timeout     = number
  })
  default = {
    name        = null
    working_dir = "/root"
    type        = "RunShellScript"
    timeout     = 3600
  }
}

variable "ecs_invocation_config" {
  description = "ECS invocation configuration"
  type = object({
    create_timeout = string
  })
  default = {
    create_timeout = "5m"
  }
}

variable "enable_ecs_invocation" {
  description = "Whether to enable ECS command invocation for AI application deployment. Set to false to skip the deployment step"
  type        = bool
  default     = true
}

variable "custom_deployment_script" {
  description = "Custom deployment script for AI application. If not provided, the default script will be used"
  type        = string
  default     = null
  sensitive   = true
}