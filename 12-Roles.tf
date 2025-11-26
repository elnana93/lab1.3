# =========================================
# 1️⃣ Create the OIDC provider for GitHub Actions
# =========================================
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

# =========================================
# 2️⃣ IAM Policy for S3 access
# =========================================
resource "aws_iam_policy" "github_s3_policy" {
  name        = "GitHubActions"
  description = "Policy for GitHub Actions access"

  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [

    {
      "Effect": "Allow",
      "Action": [
        "ec2:*"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "elasticloadbalancing:*"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "autoscaling:*"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:PutRolePolicy",
        "iam:DeleteRolePolicy",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:CreateInstanceProfile",
        "iam:DeleteInstanceProfile",
        "iam:AddRoleToInstanceProfile",
        "iam:RemoveRoleFromInstanceProfile",
        "iam:ListRolePolicies",
        "iam:ListAttachedRolePolicies",
        "iam:GetRole",
        "iam:PassRole"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "secretsmanager:*"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "*"
    },

    {
      "Effect": "Allow",
      "Action": [
        "tag:*"
      ],
      "Resource": "*"
    }
  ]
}
)
}

# =========================================
# 3️⃣ IAM Role for GitHub Actions
# =========================================
resource "aws_iam_role" "github_actions_role" {
  name = "GitHubActionsRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = "arn:aws:iam::676373376093:oidc-provider/token.actions.githubusercontent.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:elnana93/lab1.3:ref:refs/heads/main"
          }
        }
      }
    ]
  })
}

# =========================================
# 4️⃣ Attach S3 Policy to the role
# =========================================

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_s3_policy.arn
}

# =========================================
# 5️⃣ Output the Role ARN for GitHub Actions
# =========================================
output "actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "Role ARN to use in GitHub Actions"
}