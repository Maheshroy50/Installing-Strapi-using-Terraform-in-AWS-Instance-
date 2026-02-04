
# Data source for AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Generate random secrets for Strapi
resource "random_password" "app_keys_1" {
  length  = 16
  special = false
}
resource "random_password" "app_keys_2" {
  length  = 16
  special = false
}
resource "random_password" "app_keys_3" {
  length  = 16
  special = false
}
resource "random_password" "app_keys_4" {
  length  = 16
  special = false
}

resource "random_password" "api_token_salt" {
  length  = 32
  special = false
}
resource "random_password" "admin_jwt_secret" {
  length  = 32
  special = false
}
resource "random_password" "transfer_token_salt" {
  length  = 32
  special = false
}
resource "random_password" "jwt_secret" {
  length  = 32
  special = false
}

# Key Pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh

  tags = {
    Name        = var.key_name
    Environment = var.environment
  }
}

resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# EC2 Instance
resource "aws_instance" "strapi_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = var.security_group_ids

  tags = {
    Name        = var.instance_name
    Environment = var.environment
  }

  user_data = templatefile("${path.module}/setup.sh", {
    app_keys            = "${random_password.app_keys_1.result},${random_password.app_keys_2.result},${random_password.app_keys_3.result},${random_password.app_keys_4.result}"
    api_token_salt      = random_password.api_token_salt.result
    admin_jwt_secret    = random_password.admin_jwt_secret.result
    transfer_token_salt = random_password.transfer_token_salt.result
    jwt_secret          = random_password.jwt_secret.result
  })

  # Replacing old dependencies
  # We are moving away from flat structure, so no direct dependency here on root resources
}
