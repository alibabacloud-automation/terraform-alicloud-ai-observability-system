# Alicloud AI Application Observability System Terraform Module

================================================ 

terraform-alicloud-ai-observability-system

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-ai-observability-system/blob/master/README-CN.md)

## Description

Terraform module which creates an observability system for AI applications at low cost using ARMS monitoring on Alibaba Cloud. This module provides a complete infrastructure solution for deploying and monitoring AI applications with real-time observability capabilities.

This module automatically provisions:
- VPC network infrastructure with secure isolation
- ECS instances optimized for AI application hosting
- RAM users with appropriate permissions for service authorization
- ARMS monitoring integration for comprehensive observability
- Security groups with configurable access rules
- Automated AI application deployment with monitoring capabilities (optional)

## Usage

This module creates a complete AI application observability system including VPC network infrastructure, ECS instances for hosting AI applications, RAM users for service authorization, and ARMS monitoring integration. The module automatically deploys and configures an AI application with monitoring capabilities.

```terraform
data "alicloud_zones" "default" {
  available_disk_category     = "cloud_essd"
  available_resource_creation = "VSwitch"
  available_instance_type     = "ecs.t6-c1m2.large"
}

data "alicloud_images" "default" {
  name_regex  = "^ubuntu_24_04_x64_20G_alibase_.*"
  most_recent = true
  owners      = "system"
}

module "ai_observability_system" {
  source = "alibabacloud-automation/ai-observability-system/alicloud"

  name_prefix = "my-ai-app"
  region      = "cn-shanghai"

  vpc_config = {
    cidr_block = "192.168.0.0/16"
  }

  vswitch_config = {
    cidr_block = "192.168.0.0/24"
    zone_id    = data.alicloud_zones.default.zones[0].id
  }

  instance_config = {
    image_id             = data.alicloud_images.default.images[0].id
    instance_type        = "ecs.t6-c1m2.large"
    system_disk_category = "cloud_essd"
    password             = "YourSecurePassword123!"
  }

  arms_config = {
    app_name     = "llm_app"
    is_public    = true
    license_key  = "your-arms-license-key"
  }

  bai_lian_config = {
    api_key = "your-bailian-api-key"
  }

  # Optional: Enable automatic deployment (may take time)
  enable_ecs_invocation = true
}
```

## Examples

* [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-ai-observability-system/tree/main/examples/complete)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.210.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## Prerequisites

Before using this module, ensure you have:

1. **Alibaba Cloud Account**: With sufficient permissions to create VPC, ECS, RAM, and ARMS resources
2. **ARMS License Key**: Obtain from [DescribeTraceLicenseKey API](https://api.aliyun.com/api/ARMS/2019-08-08/DescribeTraceLicenseKey)
3. **Bailian API Key**: Obtain from [Model Studio](https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key)
4. **Terraform**: Version >= 1.0
5. **Alibaba Cloud Provider**: Version >= 1.210.0

<!-- BEGIN_TF_DOCS -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arms_config"></a> [arms\_config](#input\_arms\_config) | ARMS (Application Real-Time Monitoring Service) configuration | <pre>object({<br>    app_name    = string<br>    is_public   = bool<br>    license_key = string<br>  })</pre> | <pre>{<br>  "app_name": "llm_app",<br>  "is_public": true,<br>  "license_key": null<br>}</pre> | no |
| <a name="input_bai_lian_config"></a> [bai\_lian\_config](#input\_bai\_lian\_config) | Bailian (DashScope) API configuration | <pre>object({<br>    api_key = string<br>  })</pre> | <pre>{<br>  "api_key": null<br>}</pre> | no |
| <a name="input_common_name_prefix"></a> [common\_name\_prefix](#input\_common\_name\_prefix) | Common prefix for resource naming. If not provided, only random suffix will be used | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | ECS command configuration for deploying AI application | <pre>object({<br>    name             = optional(string, null)<br>    command_template = string<br>    working_dir      = string<br>    type             = string<br>    timeout          = number<br>  })</pre> | <pre>{<br>  "command_template": "#!/bin/bash\nexport ARMS_APP_NAME=${arms_app_name}\nexport ARMS_REGION_ID=${arms_region_id}\nexport ARMS_IS_PUBLIC=${arms_is_public}\nexport ARMS_LICENSE_KEY=${arms_license_key}\nexport DASHSCOPE_API_KEY=${dashscope_api_key}\n\ncurl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/ai-observable/install.sh | bash\n",<br>  "timeout": 3600,<br>  "type": "RunShellScript",<br>  "working_dir": "/root"<br>}</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS invocation configuration | <pre>object({<br>    create_timeout = string<br>  })</pre> | <pre>{<br>  "create_timeout": "5m"<br>}</pre> | no |
| <a name="input_enable_ecs_invocation"></a> [enable\_ecs\_invocation](#input\_enable\_ecs\_invocation) | Whether to enable ECS command invocation for AI application deployment. Set to false to skip the deployment step | `bool` | `true` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS instance configuration. The 'image\_id', 'instance\_type', 'system\_disk\_category', and 'password' attributes are required | <pre>object({<br>    image_id                   = string<br>    instance_type              = string<br>    system_disk_category       = string<br>    password                   = string<br>    instance_name              = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 5)<br>  })</pre> | <pre>{<br>  "image_id": null,<br>  "instance_type": "ecs.t6-c1m2.large",<br>  "password": null,<br>  "system_disk_category": "cloud_essd"<br>}</pre> | no |
| <a name="input_ram_policy_attachment_config"></a> [ram\_policy\_attachment\_config](#input\_ram\_policy\_attachment\_config) | RAM policy attachment configuration | <pre>object({<br>    policy_type = string<br>    policy_name = string<br>  })</pre> | <pre>{<br>  "policy_name": "AliyunLogFullAccess",<br>  "policy_type": "System"<br>}</pre> | no |
| <a name="input_ram_user_config"></a> [ram\_user\_config](#input\_ram\_user\_config) | RAM user configuration for service access authorization | <pre>object({<br>    name = optional(string, null)<br>  })</pre> | `{}` | no |
| <a name="input_random_suffix_config"></a> [random\_suffix\_config](#input\_random\_suffix\_config) | Configuration for random suffix generation to ensure unique resource naming | <pre>object({<br>    length  = number<br>    lower   = bool<br>    upper   = bool<br>    numeric = bool<br>    special = bool<br>  })</pre> | <pre>{<br>  "length": 8,<br>  "lower": true,<br>  "numeric": false,<br>  "special": false,<br>  "upper": false<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | The Alibaba Cloud region to deploy resources. If not specified, cn-shanghai will be used | `string` | `"cn-shanghai"` | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Security group configuration | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, "Security group for AI application observability system")<br>  })</pre> | <pre>{<br>  "description": "Security group for AI application observability system"<br>}</pre> | no |
| <a name="input_security_group_rule_config"></a> [security\_group\_rule\_config](#input\_security\_group\_rule\_config) | Security group rule configuration for allowing access to application port | <pre>object({<br>    type        = string<br>    ip_protocol = string<br>    nic_type    = string<br>    policy      = string<br>    port_range  = string<br>    priority    = number<br>    cidr_ip     = string<br>  })</pre> | <pre>{<br>  "cidr_ip": "192.168.0.0/24",<br>  "ip_protocol": "tcp",<br>  "nic_type": "intranet",<br>  "policy": "accept",<br>  "port_range": "8000/8000",<br>  "priority": 1,<br>  "type": "ingress"<br>}</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration. The 'cidr\_block' attribute is required | <pre>object({<br>    cidr_block = string<br>    vpc_name   = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/16"<br>}</pre> | no |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | VSwitch configuration. The 'cidr\_block' and 'zone\_id' attributes are required | <pre>object({<br>    cidr_block   = string<br>    zone_id      = string<br>    vswitch_name = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/24",<br>  "zone_id": null<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_access_info"></a> [application\_access\_info](#output\_application\_access\_info) | Information for accessing the deployed AI application |
| <a name="output_common_name"></a> [common\_name](#output\_common\_name) | The common name used for resource naming |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command for AI application deployment |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS command invocation |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | The ECS workbench login address for the deployed instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the ECS instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_ram_access_key_id"></a> [ram\_access\_key\_id](#output\_ram\_access\_key\_id) | The access key ID of the RAM user |
| <a name="output_ram_access_key_secret"></a> [ram\_access\_key\_secret](#output\_ram\_access\_key\_secret) | The access key secret of the RAM user |
| <a name="output_ram_user_name"></a> [ram\_user\_name](#output\_ram\_user\_name) | The name of the RAM user |
| <a name="output_region"></a> [region](#output\_region) | The region where resources are deployed |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## Submit Issues

If you have any problems when using this module, please opening
a [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend opening an issue on this repo.

## Authors

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## License

MIT Licensed. See LICENSE for full details.

## Reference

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)