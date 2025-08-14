# Terraform Examples

## Good (secure) example
- `main.good.tf` is a minimal, least-privilege security group:
  - Allows **HTTPS (443)** only from **trusted CIDRs**
  - **No SSH/RDP** ingress
  - Provider pinned (`aws ~> 5.0`)
  - Tagged for ownership and inventory

### Quick start
```bash
cd examples/terraform
terraform init
terraform plan -var='vpc_id=vpc-0123456789abcdef0' \
  -var='allowed_https_cidrs=["203.0.113.0/24"]'
```

> This is a teaching sample. Review defaults before applying in any environment
