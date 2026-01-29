# 阿里云 AI 应用可观测性系统 Terraform 模块

================================================ 

terraform-alicloud-ai-observability-system

[English](https://github.com/terraform-alicloud-modules/terraform-alicloud-ai-observability-system/blob/master/README.md) | 简体中文

## 描述

使用阿里云 ARMS 监控为 AI 应用构建低成本可观测性系统的 Terraform 模块。该模块提供了一个完整的基础设施解决方案，用于部署和监控具有实时可观测性能力的 AI 应用。

该模块自动提供：
- 具有安全隔离的 VPC 网络基础设施
- 为 AI 应用托管优化的 ECS 实例
- 用于全面可观测性的 ARMS 监控集成
- 具有可配置访问规则的安全组
- 具有监控功能的自动化 AI 应用部署（可选）

## 使用方法

该模块创建一个完整的 AI 应用可观测性系统，包括 VPC 网络基础设施、用于托管 AI 应用的 ECS 实例、用于服务授权的 RAM 用户，以及 ARMS 监控集成。模块会自动部署和配置具有监控能力的 AI 应用。

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

  common_name_prefix = "my-ai-app"
  region            = "cn-shanghai"

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

  # 可选：启用自动部署（可能需要时间）
  enable_ecs_invocation = true
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-ai-observability-system/tree/main/examples/complete)

## 依赖要求

| 名称 | 版本 |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.210.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.1 |

## 前置条件

在使用此模块之前，请确保您具有：

1. **阿里云账户**：具有创建 VPC、ECS、RAM 和 ARMS 资源的充分权限
2. **ARMS 许可证密钥**：从 [DescribeTraceLicenseKey API](https://api.aliyun.com/api/ARMS/2019-08-08/DescribeTraceLicenseKey) 获取
3. **百炼 API 密钥**：从 [模型工作室](https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key) 获取
4. **Terraform**：版本 >= 1.0
5. **阿里云 Provider**：版本 >= 1.210.0

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.210.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | 1.269.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_ecs_command.run_command](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_command) | resource |
| [alicloud_ecs_invocation.invoke_script](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/ecs_invocation) | resource |
| [alicloud_instance.ecs_instance](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/instance) | resource |
| [alicloud_security_group.security_group](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group) | resource |
| [alicloud_security_group_rule.allow_app_ports](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/security_group_rule) | resource |
| [alicloud_vpc.vpc](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.vswitch](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_regions.current](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_arms_config"></a> [arms\_config](#input\_arms\_config) | ARMS (Application Real-Time Monitoring Service) configuration | <pre>object({<br>    app_name    = string<br>    is_public   = bool<br>    license_key = string<br>  })</pre> | <pre>{<br>  "app_name": "llm_app",<br>  "is_public": true,<br>  "license_key": null<br>}</pre> | no |
| <a name="input_bai_lian_config"></a> [bai\_lian\_config](#input\_bai\_lian\_config) | Bailian (DashScope) API configuration | <pre>object({<br>    api_key = string<br>  })</pre> | <pre>{<br>  "api_key": null<br>}</pre> | no |
| <a name="input_custom_deployment_script"></a> [custom\_deployment\_script](#input\_custom\_deployment\_script) | Custom deployment script for AI application. If not provided, the default script will be used | `string` | `null` | no |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | ECS command configuration for deploying AI application | <pre>object({<br>    name        = optional(string, null)<br>    working_dir = string<br>    type        = string<br>    timeout     = number<br>  })</pre> | <pre>{<br>  "name": null,<br>  "timeout": 3600,<br>  "type": "RunShellScript",<br>  "working_dir": "/root"<br>}</pre> | no |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS invocation configuration | <pre>object({<br>    create_timeout = string<br>  })</pre> | <pre>{<br>  "create_timeout": "5m"<br>}</pre> | no |
| <a name="input_enable_ecs_invocation"></a> [enable\_ecs\_invocation](#input\_enable\_ecs\_invocation) | Whether to enable ECS command invocation for AI application deployment. Set to false to skip the deployment step | `bool` | `true` | no |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS instance configuration. The 'image\_id', 'instance\_type', 'system\_disk\_category', and 'password' attributes are required | <pre>object({<br>    image_id                   = string<br>    instance_type              = string<br>    system_disk_category       = string<br>    password                   = string<br>    instance_name              = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 5)<br>  })</pre> | <pre>{<br>  "image_id": null,<br>  "instance_name": null,<br>  "instance_type": "ecs.t6-c1m2.large",<br>  "internet_max_bandwidth_out": 5,<br>  "password": null,<br>  "system_disk_category": "cloud_essd"<br>}</pre> | no |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | Security group configuration | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, "Security group for AI application observability system")<br>  })</pre> | <pre>{<br>  "description": "Security group for AI application observability system",<br>  "security_group_name": null<br>}</pre> | no |
| <a name="input_security_group_rule_configs"></a> [security\_group\_rule\_configs](#input\_security\_group\_rule\_configs) | Security group rules configuration for allowing access to application ports | <pre>list(object({<br>    type        = string<br>    ip_protocol = string<br>    nic_type    = string<br>    policy      = string<br>    port_range  = string<br>    priority    = number<br>    cidr_ip     = string<br>  }))</pre> | <pre>[<br>  {<br>    "cidr_ip": "192.168.0.0/24",<br>    "ip_protocol": "tcp",<br>    "nic_type": "intranet",<br>    "policy": "accept",<br>    "port_range": "8000/8000",<br>    "priority": 1,<br>    "type": "ingress"<br>  }<br>]</pre> | no |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC configuration. The 'cidr\_block' attribute is required | <pre>object({<br>    cidr_block = string<br>    vpc_name   = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/16",<br>  "vpc_name": null<br>}</pre> | no |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | VSwitch configuration. The 'cidr\_block' and 'zone\_id' attributes are required | <pre>object({<br>    cidr_block   = string<br>    zone_id      = string<br>    vswitch_name = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/24",<br>  "vswitch_name": null,<br>  "zone_id": null<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_access_info"></a> [application\_access\_info](#output\_application\_access\_info) | Information for accessing the deployed AI application |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | The ID of the ECS command for AI application deployment |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | The ID of the ECS command invocation |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | The ECS workbench login address for the deployed instance |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | The ID of the ECS instance |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | The private IP address of the ECS instance |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | The public IP address of the ECS instance |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | The ID of the VSwitch |
<!-- END_TF_DOCS -->

## 提交问题

如果您在使用此模块时遇到任何问题，请提交一个 [provider issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new) 并告知我们。

**注意：** 不建议在此仓库中提交问题。

## 作者

由阿里云 Terraform 团队创建和维护(terraform@alibabacloud.com)。

## 许可证

MIT 许可。有关完整详细信息，请参阅 LICENSE。

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)