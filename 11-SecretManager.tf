
#_____
#  Option 2: Force Delete the Secret Immediately
# If you want to completely remove the old one right now:


# bash
# Copy
# Edit
#this is for to delete the secrets

# aws secretsmanager delete-secret \
#   --secret-id my-application-secret \
#   --force-delete-without-recovery

# ⚠️ Warning: This is permanent — the secret will be gone instantly.
#_____

resource "aws_secretsmanager_secret" "my_secret" {
  name        = "my-application-secret"
  description = "Secret for my app1"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = aws_secretsmanager_secret.my_secret.id

  secret_string = jsonencode({
    username = var.secret_username
    password = var.secret_password
  })
}

output "secret_arn" {
  value     = aws_secretsmanager_secret.my_secret.arn
  sensitive = true
}


variable "secret_username" {
  description = "The username for the app secret"
  type        = string
  sensitive   = true
}

variable "secret_password" {
  description = "The password for the app secret"
  type        = string
  sensitive   = true
}



    # export TF_VAR_secret_password="s3cr3t123!"
