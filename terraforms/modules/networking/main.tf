
resource "aws_security_group" "allow_ssh" {
  name_prefix = "allow-ssh-"
  description = "Security group for EC2 instance - allows SSH, HTTP, and HTTPS"

  tags = {
    Name        = "ec2-security-group"
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  for_each = toset(var.allowed_ssh_cidr)

  security_group_id = aws_security_group.allow_ssh.id

  description = "SSH access from ${each.value}"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = each.value

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.allow_ssh.id

  description = "HTTP inbound traffic"
  from_port   = 80
  to_port     = 80
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "allow-http"
  }
}

resource "aws_vpc_security_group_ingress_rule" "strapi" {
  security_group_id = aws_security_group.allow_ssh.id

  description = "Strapi application port"
  from_port   = 1337
  to_port     = 1337
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "allow-strapi"
  }
}

resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.allow_ssh.id

  description = "Allow all outbound traffic"
  from_port   = -1
  to_port     = -1
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"

  tags = {
    Name = "allow-all-outbound"
  }
}
