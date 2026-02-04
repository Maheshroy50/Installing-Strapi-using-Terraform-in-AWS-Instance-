# Terraform Strapi Infrastructure Deployment

A complete Terraform infrastructure setup to automate EC2 deployment with Strapi CMS running in development mode.

## Project Structure

```
.
├── terraforms/
│   ├── main.tf                 # EC2 instance configuration
│   ├── provider.tf             # AWS provider setup
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   ├── security.tf             # Security group rules
│   ├── keypair.tf              # SSH key pair generation
│   ├── locals.tf               # Local variables
│   ├── terraform.tfvars.example # Example variables file
│   └── modules/
│       └── compute/
│           └── setup.sh        # EC2 user_data script
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

## Task 1: Terraform Infrastructure Setup

Created modular Terraform configuration with:
- **provider.tf**: AWS provider configuration with default tags
- **variables.tf**: Parameterized inputs for reusability
- **main.tf**: EC2 instance resource
- **security.tf**: Security group with SSH, HTTP, HTTPS, and Strapi (1337) port access
- **keypair.tf**: Automated SSH key pair generation
- **outputs.tf**: Public IP, DNS, and SSH command outputs

## Task 2: Ubuntu AMI Migration

- Switched from Amazon Linux 2 to **Ubuntu 22.04 LTS** (Free Tier eligible)
- Uses Canonical's official AMI (owner: 099720109477)
- Dynamically fetches the latest version for security updates

## Task 3: Strapi Deployment - Issues & Solutions

### Initial Approach: t3.micro with npm install (FAILED)

**Issue**: `npm install` was killed due to insufficient memory
```
/var/lib/cloud/instance/scripts/part-001: line 23: 8820 Killed npm install
```

**Root Cause**: t3.micro instance has only **1GB RAM**, insufficient for Strapi dependency installation (~2GB required).

**Solution**: Upgraded instance type from **t3.micro** to **t3.small** (2GB RAM)
- t3.small provides adequate memory for npm install and development mode
- Trade-off: Not free tier (~$0.02/hour or ~$15/month)
- Alternative: Use Docker for more efficient memory usage (not implemented in current setup)

### Second Issue: Missing Uploads Directory

**Error**: 
```
Error: The upload folder (/opt/strapi/public/uploads) doesn't exist or is not accessible
```

**Root Cause**: Strapi's local upload provider requires the `public/uploads` directory to exist during startup.

**Solution**: Updated user_data script to create required directories:
```bash
mkdir -p /opt/strapi/public/uploads
mkdir -p /opt/strapi/.tmp
chown -R root:root /opt/strapi
```

**Location**: [modules/compute/setup.sh](terraforms/modules/compute/setup.sh#L55-L58)

## Deployment Instructions

### Prerequisites

1. AWS Account with credentials configured
2. Terraform installed (v1.0+)
3. SSH client

### Step 1: Initialize Terraform

```bash
cd terraforms/
terraform init
```

### Step 2: Configure Variables (Optional)

Copy and customize the example variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` if you want custom values:
```hcl
aws_region    = "us-east-1"
instance_type = "t3.small"
key_name      = "my-strapi-key"
```

### Step 3: Plan & Apply

```bash
terraform plan
terraform apply
```

Terraform will output:
- EC2 instance public IP
- SSH connection command
- Private key file location

### Step 4: Wait for Initialization

The user_data script runs automatically on instance startup. Wait **10-15 minutes** for:
- System updates
- Node.js installation
- Repository clone
- npm dependencies installation
- Strapi startup in dev mode

Monitor progress:
```bash
# SSH into the instance
ssh -i my-terraform-key.pem ubuntu@<PUBLIC_IP>

# Check systemd service status
systemctl status strapi

# View live logs
journalctl -u strapi -f
```

### Step 5: Access Strapi

Once fully initialized, access Strapi at:

```
http://<PUBLIC_IP>:1337
```

Or use the SSH command output by Terraform:
```bash
terraform output ssh_command
```

## Configuration

### Environment Variables

The setup script creates a `.env` file with:
- **HOST**: 0.0.0.0 (accessible from external IP)
- **PORT**: 1337
- **NODE_ENV**: development
- **DATABASE**: SQLite (.tmp/data.db)

For production, configure additional secrets in `terraform.tfvars`:
```hcl
app_keys            = "your-secure-key"
api_token_salt      = "your-secure-salt"
admin_jwt_secret    = "your-jwt-secret"
transfer_token_salt = "your-transfer-salt"
jwt_secret          = "your-jwt-secret"
```

### Ports

Security group allows:
- **22**: SSH access
- **80**: HTTP
- **443**: HTTPS
- **1337**: Strapi development server

## Cleanup

Destroy all resources and stop incurring costs:

```bash
terraform destroy
```

## Lessons Learned

1. **Memory Requirements**: Development mode requires sufficient RAM. t3.micro insufficient for npm install.
2. **Directory Initialization**: Strapi plugins expect certain directories to exist at startup.
3. **Startup Time**: Allow 10-15 minutes for full initialization including npm install and Strapi boot.
4. **Logs**: Always check cloud-init logs (`/var/log/cloud-init-output.log`) and systemd logs for troubleshooting.

## Troubleshooting

### Strapi service keeps restarting
```bash
systemctl status strapi
journalctl -u strapi -n 50
```

### Connection refused on port 1337
- Instance still initializing (wait 10-15 minutes)
- Check security group allows port 1337
- Verify Strapi process is running: `ps aux | grep strapi`

### npm install killed
- Insufficient RAM (upgrade to t3.small or larger)
- Check available memory: `free -h`

### SSH connection timeout
- Wait 2-3 minutes for instance to fully initialize
- Verify instance is running: `terraform show`
- Check security group SSH rule is applied

## Files Reference

- [main.tf](terraforms/main.tf) - EC2 instance with user_data script
- [security.tf](terraforms/security.tf) - Security group configuration
- [keypair.tf](terraforms/keypair.tf) - SSH key generation
- [setup.sh](terraforms/modules/compute/setup.sh) - Strapi installation script
- [.gitignore](.gitignore) - Git ignore rules for sensitive files

## Next Steps

1. Test Strapi deployment in production mode
2. Implement RDS for persistent database
3. Add CloudFront for CDN
4. Set up auto-scaling with Application Load Balancer
5. Implement CI/CD pipeline for automated deployments
