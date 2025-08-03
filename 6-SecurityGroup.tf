
# Security Group for the ELB
resource "aws_security_group" "app1-sg02-LB01" {
  name        = "app1-sg02-LB01"
  description = "Allow HTTP from anywhere"
  vpc_id      = aws_vpc.app1.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app1-sg02-LB01"
  }
}

# Security Group for the EC2 instances
resource "aws_security_group" "app1-sg01-servers" {
  name        = "app1-sg01-servers"
  description = "Security group for App1 EC2 instances"
  vpc_id      = aws_vpc.app1.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.app1-sg02-LB01.id]
  }

  # added this because i want to ssh into my instance
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["79.110.54.62/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "app1-sg01-servers"
  }
}




