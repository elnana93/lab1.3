

resource "aws_iam_user" "app_user1" {
  name          = var.iam_user_name
  force_destroy = true

  tags = {
    Name = var.iam_user_name
  }
}

resource "aws_iam_user_login_profile" "login_profile" {
  user                    = aws_iam_user.app_user1.name
  password_reset_required = true
}


variable "iam_user_name" {
  description = "The name of the IAM user"
  type        = string
}

variable "iam_user_password" {
  description = "The initial password for the IAM user"
  type        = string
  sensitive   = true
}


output "iam_user_sign_in_url" {
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  description = "IAM user sign-in URL for AWS Management Console"
}

data "aws_caller_identity" "current" {}





#________________________________________
# Policy 1 – EC2 & CloudWatch (Limit destructive actions)
resource "aws_iam_policy" "user_policy_1" {
  name        = "user_policy1"
  description = "For Cloud Watch - CloudWatchActionsEC2Access"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:Describe*",
          "ec2:Describe*",
          "ec2:RebootInstances",
          "ec2:StopInstances",
        ],
        Resource = "*"
      }
    ]
    }
  )
}

# Policy 2 – Load balancer access
resource "aws_iam_policy" "user_policy_2" {
  name        = "user_policy2"
  description = "For Loadbalancer - AWSElasticLoadBalancingClassicServiceRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:DescribeAddresses",
          "ec2:DescribeInstances",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeInternetGateways",
          "ec2:DescribeAccountAttributes",
          "ec2:DescribeClassicLinkInstances",
          "ec2:DescribeVpcClassicLink",
          "ec2:CreateSecurityGroup",
          "ec2:CreateNetworkInterface",
          "ec2:DeleteNetworkInterface",
          "ec2:ModifyNetworkInterfaceAttribute",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:AssociateAddress",
          "ec2:DisassociateAddress",
          "ec2:AttachNetworkInterface",
          "ec2:DetachNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:AssignIpv6Addresses",
          "ec2:UnassignIpv6Addresses"
        ],
        Resource = "*"
      }
    ]
  })
}



# Policy 3 – For secrets manger-for IAM User
resource "aws_iam_policy" "user_policy_3" {
  name        = "user_policy3"
  description = "Allow full access to specific Secrets Manager secret"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowSecretReadWriteAccess",
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:PutSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "arn:aws:secretsmanager:us-west-2:676373376093:secret:my-application-secret-CFyW5r"
      },
      {
        Sid    = "AllowSecretCreationAndDeletion",
        Effect = "Allow",
        Action = [
          "secretsmanager:CreateSecret",
          "secretsmanager:DeleteSecret"
        ],
        Resource = "*"
      }
    ]
  })
}



# Policy 4 – For IAM User password
resource "aws_iam_policy" "user_policy_4" {
  name = "user-policy-4"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "iam:ChangePassword"
        ]
        Resource = [
          "arn:aws:iam::*:user/$${aws:username}",
          "arn:aws:iam::*:user/*/$${aws:username}"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "iam:GetAccountPasswordPolicy"
        ]
        Resource = "*"
      }
    ]
  })
}




# Attach policies to IAM user
resource "aws_iam_user_policy_attachment" "attach_policy1" {
  user       = aws_iam_user.app_user1.name
  policy_arn = aws_iam_policy.user_policy_1.arn
}

resource "aws_iam_user_policy_attachment" "attach_policy2" {
  user       = aws_iam_user.app_user1.name
  policy_arn = aws_iam_policy.user_policy_2.arn
}

resource "aws_iam_user_policy_attachment" "attach_policy3" {
  user       = aws_iam_user.app_user1.name
  policy_arn = aws_iam_policy.user_policy_3.arn
}

resource "aws_iam_user_policy_attachment" "attach_policy4" {
  user       = aws_iam_user.app_user1.name
  policy_arn = aws_iam_policy.user_policy_4.arn
}



#This works Finally!!!!
#https://stackoverflow.com/questions/70363655/creating-iam-user-with-change-password-on-login-option-using-terraform
