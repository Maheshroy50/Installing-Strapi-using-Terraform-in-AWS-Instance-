provider "aws" {
  region = "us-east-1"
}

# 1. Create a Secure Key Pair for SSH access
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "my-terraform-key"
  public_key = tls_private_key.example.public_key_openssh
}

# 2. Save the Private Key locally so you can login
resource "local_file" "private_key" {
  content         = tls_private_key.example.private_key_pem
  filename        = "${path.module}/my-key.pem"
  file_permission = "0400" # Read-only for owner (required for SSH keys)
}

# 3. Create a Security Group to allow SSH traffic
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Open to the world (Warning: Use your IP in production)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI
  instance_type = "t2.micro"

  # 4. Attach Key Pair and Security Group
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "MyFirstInstance"
  }
}

# 5. Output the Public IP to connect easily
output "instance_ip" {
  description = "The public IP of the instance"
  value       = aws_instance.my_ec2.public_ip
}
