variable "region" {
  type        = string
  description = "AWS region"
  default     = "ap-southeast-2"
}

variable "vpc_id" {
  type        = string
  description = "Target VPC ID (e.g., vpc-0123456789abcdef0)"
}

variable "app_name" {
  type        = string
  description = "Application/service name"
  default     = "cnciso-app"
}

variable "environment" {
  type        = string
  description = "Environment tag (e.g., dev|staging|prod)"
  default     = "dev"
}

variable "owner" {
  type        = string
  description = "Owner or team identifier"
  default     = "platform-security"
}

variable "allowed_https_cidrs" {
  type        = list(string)
  description = "Trusted CIDR blocks allowed to access HTTPS (443)"
  default     = ["203.0.113.0/24"] # replace with your org egress/VPN CIDR
}
