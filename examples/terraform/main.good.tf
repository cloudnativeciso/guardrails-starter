#############################################
# Secure by Default – Terraform (GOOD)
# - Least-privilege Security Group
# - HTTPS only from trusted CIDRs
# - No public egress (defaults to RFC1918 only)
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

resource "aws_security_group" "app_sg" {
  name        = "${var.app_name}-sg"
  description = "Restrictive SG for ${var.app_name} (${var.environment})"
  vpc_id      = var.vpc_id

  # Ingress: HTTPS from approved CIDRs only
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

  # Egress: default-deny public; allow only approved private destinations (RFC1918 by default)
  dynamic "egress" {
    for_each = var.egress_cidrs
    content {
      description      = "Restricted egress"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = [egress.value]
      ipv6_cidr_blocks = []
    }
  }

  tags = {
    Name        = "${var.app_name}-sg"
    Environment = var.environment
    Owner       = var.owner
    ManagedBy   = "terraform"
    Purpose     = "app-ingress"
  }
}

output "app_sg_id" {
  value       = aws_security_group.app_sg.id
  description = "ID of the application security group"
}
