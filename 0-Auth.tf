provider "aws" {
  region  = "us-west-2"
  profile = "default"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Cmd + Shift + . to toggle showing hidden files and folders visually

#terraform fmt- to fix your lines 

# Shift + Alt + A - To block out everything


/*  to ssh into your instance hit this command on bash 
 "ssh -i keylab1.3.pem ec2-user@34.219.139.148"
 "curl ifconfig.me" - hit this on bash to find your cidr block aka ip address */



/* for exsisting plays
 git status
 git add assets/index.html
 git add .github/workflows/deploy.yml
 git commit -m "Add fixed deploy workflow"
 git push */