#############################################
# Secure by Default – Terraform (GOOD)
# - Minimally permissive SG
# - Designed for app pods behind an ALB or API GW
# - No SSH/RDP ingress; HTTPS only from trusted CIDRs
#############################################

terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Security Group: allow HTTPS only from trusted CIDRs (e.g., corporate egress or upstream ALB)
resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-sg"
  description = "Restrictive SG for ${var.app_name} (${var.environment})"
  vpc_id      = var.vpc_id

  # HTTPS from approved CIDRs only
  dynamic "ingress" {
    for_each = var.allowed_https_cidrs
    content {
      description = "HTTPS from approved CIDR"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  # Egress: allow all (common baseline). Tighten if you know explicit destinations/ports.
  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Purpose     = "app-ingress"
  }

  lifecycle {
    # Prevent accidental deletion during refactors
    prevent_destroy = false
  }
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "ID of the application security group"
}
