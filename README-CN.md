# 阿里云 AI 应用可观测性系统 Terraform 模块

================================================ 

terraform-alicloud-ai-observability-system

[English](https://github.com/terraform-alicloud-modules/terraform-alicloud-ai-observability-system/blob/master/README.md) | 简体中文

## 描述

使用阿里云 ARMS 监控为 AI 应用构建低成本可观测性系统的 Terraform 模块。该模块提供了一个完整的基础设施解决方案，用于部署和监控具有实时可观测性能力的 AI 应用。

该模块自动提供：
- 具有安全隔离的 VPC 网络基础设施
- 为 AI 应用托管优化的 ECS 实例
- 具有适当服务授权权限的 RAM 用户
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
## 输入变量

| 名称 | 描述 | 类型 | 默认值 | 必需 |
|------|-------------|------|---------|:--------:|
| <a name="input_arms_config"></a> [arms\_config](#input\_arms\_config) | ARMS（应用实时监控服务）配置 | <pre>object({<br>    app_name    = string<br>    is_public   = bool<br>    license_key = string<br>  })</pre> | <pre>{<br>  "app_name": "llm_app",<br>  "is_public": true,<br>  "license_key": null<br>}</pre> | 否 |
| <a name="input_bai_lian_config"></a> [bai\_lian\_config](#input\_bai\_lian\_config) | 百炼（DashScope）API 配置 | <pre>object({<br>    api_key = string<br>  })</pre> | <pre>{<br>  "api_key": null<br>}</pre> | 否 |
| <a name="input_common_name_prefix"></a> [common\_name\_prefix](#input\_common\_name\_prefix) | 资源命名的通用前缀。如果不提供，将只使用随机后缀 | `string` | `null` | 否 |
| <a name="input_ecs_command_config"></a> [ecs\_command\_config](#input\_ecs\_command\_config) | 用于部署 AI 应用程序的 ECS 命令配置 | <pre>object({<br>    name             = optional(string, null)<br>    command_template = string<br>    working_dir      = string<br>    type             = string<br>    timeout          = number<br>  })</pre> | <pre>{<br>  "command_template": "#!/bin/bash\nexport ARMS_APP_NAME=${arms_app_name}\nexport ARMS_REGION_ID=${arms_region_id}\nexport ARMS_IS_PUBLIC=${arms_is_public}\nexport ARMS_LICENSE_KEY=${arms_license_key}\nexport DASHSCOPE_API_KEY=${dashscope_api_key}\n\ncurl -fsSL https://help-static-aliyun-doc.aliyuncs.com/install-script/ai-observable/install.sh | bash\n",<br>  "timeout": 3600,<br>  "type": "RunShellScript",<br>  "working_dir": "/root"<br>}</pre> | 否 |
| <a name="input_ecs_invocation_config"></a> [ecs\_invocation\_config](#input\_ecs\_invocation\_config) | ECS 调用配置 | <pre>object({<br>    create_timeout = string<br>  })</pre> | <pre>{<br>  "create_timeout": "5m"<br>}</pre> | 否 |
| <a name="input_enable_ecs_invocation"></a> [enable\_ecs\_invocation](#input\_enable\_ecs\_invocation) | 是否启用 ECS 命令调用以进行 AI 应用程序部署。设置为 false 以跳过部署步骤 | `bool` | `true` | 否 |
| <a name="input_instance_config"></a> [instance\_config](#input\_instance\_config) | ECS 实例配置。'image\_id'、'instance\_type'、'system\_disk\_category' 和 'password' 属性是必需的 | <pre>object({<br>    image_id                   = string<br>    instance_type              = string<br>    system_disk_category       = string<br>    password                   = string<br>    instance_name              = optional(string, null)<br>    internet_max_bandwidth_out = optional(number, 5)<br>  })</pre> | <pre>{<br>  "image_id": null,<br>  "instance_type": "ecs.t6-c1m2.large",<br>  "password": null,<br>  "system_disk_category": "cloud_essd"<br>}</pre> | 否 |
| <a name="input_ram_policy_attachment_config"></a> [ram\_policy\_attachment\_config](#input\_ram\_policy\_attachment\_config) | RAM 策略附加配置 | <pre>object({<br>    policy_type = string<br>    policy_name = string<br>  })</pre> | <pre>{<br>  "policy_name": "AliyunLogFullAccess",<br>  "policy_type": "System"<br>}</pre> | 否 |
| <a name="input_ram_user_config"></a> [ram\_user\_config](#input\_ram\_user\_config) | 用于服务访问授权的 RAM 用户配置 | <pre>object({<br>    name = optional(string, null)<br>  })</pre> | `{}` | 否 |
| <a name="input_random_suffix_config"></a> [random\_suffix\_config](#input\_random\_suffix\_config) | 随机后缀生成配置，确保资源命名的唯一性 | <pre>object({<br>    length  = number<br>    lower   = bool<br>    upper   = bool<br>    numeric = bool<br>    special = bool<br>  })</pre> | <pre>{<br>  "length": 8,<br>  "lower": true,<br>  "numeric": false,<br>  "special": false,<br>  "upper": false<br>}</pre> | 否 |
| <a name="input_region"></a> [region](#input\_region) | 部署资源的阿里云地域。如果未指定，将使用 cn-shanghai | `string` | `"cn-shanghai"` | 否 |
| <a name="input_security_group_config"></a> [security\_group\_config](#input\_security\_group\_config) | 安全组配置 | <pre>object({<br>    security_group_name = optional(string, null)<br>    description         = optional(string, "Security group for AI application observability system")<br>  })</pre> | <pre>{<br>  "description": "Security group for AI application observability system"<br>}</pre> | 否 |
| <a name="input_security_group_rule_config"></a> [security\_group\_rule\_config](#input\_security\_group\_rule\_config) | 允许访问应用程序端口的安全组规则配置 | <pre>object({<br>    type        = string<br>    ip_protocol = string<br>    nic_type    = string<br>    policy      = string<br>    port_range  = string<br>    priority    = number<br>    cidr_ip     = string<br>  })</pre> | <pre>{<br>  "cidr_ip": "192.168.0.0/24",<br>  "ip_protocol": "tcp",<br>  "nic_type": "intranet",<br>  "policy": "accept",<br>  "port_range": "8000/8000",<br>  "priority": 1,<br>  "type": "ingress"<br>}</pre> | 否 |
| <a name="input_vpc_config"></a> [vpc\_config](#input\_vpc\_config) | VPC 配置。'cidr\_block' 属性是必需的 | <pre>object({<br>    cidr_block = string<br>    vpc_name   = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/16"<br>}</pre> | 否 |
| <a name="input_vswitch_config"></a> [vswitch\_config](#input\_vswitch\_config) | 交换机配置。'cidr\_block' 和 'zone\_id' 属性是必需的 | <pre>object({<br>    cidr_block   = string<br>    zone_id      = string<br>    vswitch_name = optional(string, null)<br>  })</pre> | <pre>{<br>  "cidr_block": "192.168.0.0/24",<br>  "zone_id": null<br>}</pre> | 否 |

## 输出

| 名称 | 描述 |
|------|-------------|
| <a name="output_application_access_info"></a> [application\_access\_info](#output\_application\_access\_info) | 访问已部署 AI 应用程序的信息 |
| <a name="output_common_name"></a> [common\_name](#output\_common\_name) | 用于资源命名的通用名称 |
| <a name="output_ecs_command_id"></a> [ecs\_command\_id](#output\_ecs\_command\_id) | 用于 AI 应用程序部署的 ECS 命令的 ID |
| <a name="output_ecs_invocation_id"></a> [ecs\_invocation\_id](#output\_ecs\_invocation\_id) | ECS 命令调用的 ID |
| <a name="output_ecs_login_address"></a> [ecs\_login\_address](#output\_ecs\_login\_address) | 已部署实例的 ECS 工作台登录地址 |
| <a name="output_instance_id"></a> [instance\_id](#output\_instance\_id) | ECS 实例的 ID |
| <a name="output_instance_private_ip"></a> [instance\_private\_ip](#output\_instance\_private\_ip) | ECS 实例的私有 IP 地址 |
| <a name="output_instance_public_ip"></a> [instance\_public\_ip](#output\_instance\_public\_ip) | ECS 实例的公有 IP 地址 |
| <a name="output_ram_access_key_id"></a> [ram\_access\_key\_id](#output\_ram\_access\_key\_id) | RAM 用户的访问密钥 ID |
| <a name="output_ram_access_key_secret"></a> [ram\_access\_key\_secret](#output\_ram\_access\_key\_secret) | RAM 用户的访问密钥密码 |
| <a name="output_ram_user_name"></a> [ram\_user\_name](#output\_ram\_user\_name) | RAM 用户的名称 |
| <a name="output_region"></a> [region](#output\_region) | 资源部署的地域 |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | 安全组的 ID |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | VPC 的 CIDR 块 |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | VPC 的 ID |
| <a name="output_vswitch_id"></a> [vswitch\_id](#output\_vswitch\_id) | 交换机的 ID |
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