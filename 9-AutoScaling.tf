
 resource "aws_autoscaling_group" "app1_asg" {
  name_prefix      = "app1-asg"
  max_size         = 3 #3
  min_size         = 3 #1
  desired_capacity = 3 #2
  vpc_zone_identifier = [
    aws_subnet.public-us-west-2a.id,
    aws_subnet.public-us-west-2b.id,
    aws_subnet.public-us-west-2c.id
  ]

  launch_template {
    id      = aws_launch_template.app1_template.id
    version = "$Latest"
  }

  enabled_metrics = ["GroupMinSize", "GroupMaxSize", "GroupDesiredCapacity", "GroupInServiceInstances", "GroupTotalInstances"]

  #Instance protection for launching
  initial_lifecycle_hook {
    name                  = "instance-protection-launch"
    lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
    default_result        = "CONTINUE"
    heartbeat_timeout     = 60
    notification_metadata = "{\"key\":\"value\"}"
  }

  # Instance protection for terminating
  initial_lifecycle_hook {
    name                 = "scale-in-protection"
    lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
    default_result       = "CONTINUE"
    heartbeat_timeout    = 300
  }

  tag {
    key                 = "Name"
    value               = "app1-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "Production"
    propagate_at_launch = true
  }

  # 👇 Classic Load Balancer attachment
  load_balancers = [aws_elb.app1_elb.name]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  force_delete = true

  tag {
    key                 = "Name"
    value               = "app1-asg-instance"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
 

