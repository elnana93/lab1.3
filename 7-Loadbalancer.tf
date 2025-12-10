/* Turn off load balancer from the cansole so that way terraform shut down run smoothly - its justa a theory for now because i still may need todelete the autoscaling as well before i hit terraform destroy */ 

 resource "aws_elb" "app1_elb" {
  name = "app1-elb"
  #   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"] # OR use subnets instead
  security_groups = [aws_security_group.app1-sg02-LB01.id]                                                              # ELB SG
  subnets         = [aws_subnet.public-us-west-2a.id, aws_subnet.public-us-west-2b.id, aws_subnet.public-us-west-2c.id] # Public subnets

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = {
    Name = "app1-classic-elb"
  }
}



output "app1_url" {
  description = "Public URL to access the application"
  value       = "http://${aws_elb.app1_elb.dns_name}"
} 

/* create a iam role instead of policy in the future to get rid of the warning signal when i terraform destroy
 */