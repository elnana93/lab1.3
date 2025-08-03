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


#terraform fmt- to fix your lines 

# to ssh into your instance hit this command on bash 
# "ssh -i keylab1.3.pem ec2-user@34.219.139.148"
# "curl ifconfig.me" - hit this on bash to find your cidr block aka ip address