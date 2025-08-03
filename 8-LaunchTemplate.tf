

resource "aws_launch_template" "app1_template" {
  name_prefix            = "app1-template-"
  image_id               = data.aws_ami.amazon_linux.id # Replace with a valid Amazon Linux AMI ID
  instance_type          = "t2.micro"
  key_name               = "keylab1.3" # Your SSH key name
  vpc_security_group_ids = [aws_security_group.app1-sg01-servers.id]

  # # 🔐 Just added this block 👇
  # iam_instance_profile {
  #   name = aws_iam_instance_profile.my_instance_profile.name
  # }

  #these are new
  monitoring {
    enabled = true
  }

  #these are new
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "Mac Rel Will Save Her!!!!! $(hostname)" > /var/www/html/index.html
              EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "app1-instance"
    }
  }

  lifecycle {
    create_before_destroy = true

  }
}


data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"] # Amazon
}
