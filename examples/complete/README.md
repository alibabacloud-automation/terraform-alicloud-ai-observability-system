# Complete Example

This example demonstrates how to use the AI Application Observability System module to deploy a complete AI application with ARMS monitoring.

## Overview

This example creates:

- A VPC with a VSwitch for network isolation
- A security group with rules for application access
- An ECS instance to host the AI application
- A RAM user with necessary permissions for log access
- ECS commands to deploy and configure the AI application with ARMS monitoring

## Prerequisites

Before running this example, ensure you have:

1. **Alibaba Cloud Account**: With sufficient permissions to create VPC, ECS, RAM, and ARMS resources
2. **ARMS License Key**: Obtain from [DescribeTraceLicenseKey API](https://api.aliyun.com/api/ARMS/2019-08-08/DescribeTraceLicenseKey)
3. **Bailian API Key**: Obtain from [Model Studio](https://help.aliyun.com/zh/model-studio/developer-reference/get-api-key)
4. **Terraform**: Version >= 1.0
5. **Alibaba Cloud Provider**: Version >= 1.210.0

## Usage

1. **Clone or download** this example to your local machine.

2. **Set up your credentials** for Alibaba Cloud provider (via environment variables, shared credentials file, or other methods).

3. **Create a terraform.tfvars file** with your specific values:

```hcl
# Required variables
ecs_password      = "YourSecurePassword123!"
arms_license_key  = "your-arms-license-key"
bai_lian_api_key  = "your-bailian-api-key"

# Optional variables (customize as needed)
region                    = "cn-shanghai"
common_name_prefix       = "my-ai-app"
allow_public_access      = true  # Set to true to allow public internet access
instance_type            = "ecs.t6-c1m2.large"
vpc_cidr_block          = "10.0.0.0/16"
vswitch_cidr_block      = "10.0.1.0/24"
```

4. **Initialize Terraform**:
```bash
terraform init
```

5. **Plan the deployment**:
```bash
terraform plan
```

6. **Apply the configuration**:
```bash
terraform apply
```

7. **Access your application**:
   - Use the `ecs_login_address` output to access the ECS instance via web console
   - Use the `application_access_info` output to get API endpoints and access information
   - The AI application will be available on port 8000

## Configuration Options

### Network Access

- **Private Access Only** (default): Set `allow_public_access = false` to restrict access to VPC internal network
- **Public Access**: Set `allow_public_access = true` to allow internet access to the application

### Instance Configuration

- **Instance Type**: Choose appropriate ECS instance type based on your performance requirements
- **System Disk**: Configure disk category and other storage options
- **Password**: Set a secure password for ECS instance login

### Monitoring Configuration

- **ARMS App Name**: Customize the application name in ARMS monitoring
- **License Key**: Required for ARMS monitoring functionality

## Outputs

After successful deployment, you'll get:

- `instance_public_ip`: Public IP address of the ECS instance
- `ecs_login_address`: Direct link to ECS web console
- `application_access_info`: Complete information for accessing the AI application
- Resource IDs for VPC, security group, RAM user, etc.

## API Usage Examples

Once deployed, you can interact with the AI application:

1. **View API Documentation**:
```bash
curl http://<instance_public_ip>:8000/docs
```

2. **Call the AI Model**:
```bash
curl -X 'POST' \
  'http://<instance_public_ip>:8000/agent/invoke' \
  -H 'Content-Type: application/json' \
  -d '{
    "input": {
      "input": "What is the weather like in Beijing?"
    }
  }'
```

## Monitoring and Observability

The deployed application automatically integrates with ARMS for:

- Application performance monitoring
- Request tracing and analysis
- Error tracking and alerting
- Custom metrics and dashboards

Access your ARMS console to view detailed monitoring information.

## Cleanup

To destroy the resources:

```bash
terraform destroy
```

## Troubleshooting

### Common Issues

1. **Permission Errors**: Ensure your Alibaba Cloud account has sufficient permissions
2. **Resource Limits**: Check regional quotas for ECS instances and other resources
3. **Network Connectivity**: Verify security group rules if you can't access the application
4. **ARMS Integration**: Ensure the license key is correct and ARMS service is enabled in your region

### Getting Help

- Check the main module documentation
- Review Alibaba Cloud provider documentation
- Verify resource configurations in the Alibaba Cloud console

## Security Considerations

- Use strong passwords for ECS instances
- Regularly rotate API keys and access credentials
- Monitor resource access through ARMS and CloudTrail
- Follow the principle of least privilege for RAM users
- Consider using private access only for production workloads