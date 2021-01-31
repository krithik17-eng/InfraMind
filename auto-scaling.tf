
resource "aws_ami_from_instance" "infra_mind_wordpress_ami" {
  name = "InfraMindWordpressAMI"
  source_instance_id = aws_instance.infra_mind_wordpress_ec2.id

  tags =  {
        Name = "WordpressAMI"
  }
}

resource "aws_launch_template" "infra_mind_wordpress_launch_template" {
	name = "WordpressLaunchTemplate"
	image_id = aws_ami_from_instance.infra_mind_wordpress_ami.id
	instance_type = var.instance_type
	key_name = var.key_name
	vpc_security_group_ids = [aws_security_group.infra_mind_wordpress_sg.id]
	subnet_id = aws_subnet.infra_mind_public_subnet.id
	tags =  {
        Name = "WordpressLaunchTemplate"
  }
}

resource "aws_autoscaling_group" "infra_mind_wordpress_autoscaling_group" {
    
    name = "WordpresAutoscalingGroup"
    availability_zones = [var.availbility_zone_1]
    max_size = "3"
    min_size = "1"
    health_check_grace_period = 300
    health_check_type = "EC2"
    force_delete = true
    load_balancers = [aws_elb.infra_mind_elb.name]

    launch_template {
    	id      = aws_launch_template.infra_mind_wordpress_launch_template.id
    	version = "$Latest"
  	}

  tag {
    key = "Name"
    value = "WordpresAutoscalingGroup"
   }
}


#resource "aws_autoscaling_policy" "infra_mind_wordpress_autoscaling_policy" {
#	name = "WordpresAutoscalingPolicy"
#	scaling_adjustment = 1
#	adjustment_type = "ChangeInCapacity"
#	cooldown = 300
#	policy_type = "SimpleScaling"
#	autoscaling_group_name = aws_autoscaling_group.infra_mind_wordpress_autoscaling_group.name
#}

resource "aws_autoscaling_policy" "infra_mind_wordpress_autoscaling_policy_scale_up" {
    name = "WordpresAutoscalingPolicyScaleUp"
    scaling_adjustment = 1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.infra_mind_wordpress_autoscaling_group.name
}

resource "aws_autoscaling_policy" "infra_mind_wordpress_autoscaling_policy_scale_down" {
    name = "WordpresAutoscalingPolicyScaleDown"
    scaling_adjustment = -1
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = aws_autoscaling_group.infra_mind_wordpress_autoscaling_group.name
}


resource "aws_cloudwatch_metric_alarm" "infra_mind_wordpress_cpu_high" {
    alarm_name = "InfraMindWordpressCPUHigh"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "System/Linux"
    period = "300"
    statistic = "Average"
    threshold = "70"
    alarm_description = "CPU Utilization Monitoring above 70%"
    alarm_actions = [
        aws_autoscaling_policy.infra_mind_wordpress_autoscaling_policy_scale_up.arn
    ]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.infra_mind_wordpress_autoscaling_group.name
    }
}


resource "aws_cloudwatch_metric_alarm" "infra_mind_wordpress_cpu_low" {
    alarm_name = "InfraMindWordpressCPULow"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods = "2"
    metric_name = "CPUUtilization"
    namespace = "System/Linux"
    period = "300"
    statistic = "Average"
    threshold = "70"
    alarm_description = "CPU Utilization Monitoring Below 70%"
    alarm_actions = [
        aws_autoscaling_policy.infra_mind_wordpress_autoscaling_policy_scale_down.arn
    ]
    dimensions = {
        AutoScalingGroupName = aws_autoscaling_group.infra_mind_wordpress_autoscaling_group.name
    }
}