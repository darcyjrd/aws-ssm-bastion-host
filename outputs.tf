output "ssh_private_key" {
  value       = tls_private_key.this.private_key_pem
  sensitive   = true
  description = "SSH Private key"
}

output "ec2_id" {
  value       = module.ec2.id
  sensitive   = false
  description = "ID of EC2 instance"
}
