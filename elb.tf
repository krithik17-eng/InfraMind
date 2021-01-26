

resource "aws_security_group" "infra_mind_elb_sg" {
	

    name = "InfraMindELBSG"
    description = "Allow HTTP Traffic from the Internet (Anywhere)"
    
    ingress {
    	description = "Allow HTTP from the Internet for ELB"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

	vpc_id = aws_vpc.infra_mind_vpc.id

    tags = {
        Name = "InfraMindELBSG"
    }
}


resource "aws_elb" "infra_mind_elb" {
    
    name = "InfraMindELB"
    subnets = [aws_subnet.infra_mind_public_subnet.id]

    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }


    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 3
        target = "HTTP:80/"
        interval = 30
    }


    security_groups = [aws_security_group.infra_mind_elb_sg.id]
    instances = [aws_instance.infra_mind_wordpress_ec2.id]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400

    tags = {
        Name = "InfraMindELB"
    }
}