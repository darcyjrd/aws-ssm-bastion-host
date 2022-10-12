resource "aws_secretsmanager_secret" "ssh" {
  name = "${var.name}-ssh-key"
}

resource "aws_secretsmanager_secret_version" "ssh" {
  secret_id     = aws_secretsmanager_secret.ssh.id
  secret_string = tls_private_key.this.private_key_pem
}
