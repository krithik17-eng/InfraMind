

resource "aws_security_group" "infra_mind_wordpress_sg" {

	name = "InfraMindWordpressSG"
	description = "Allow HTTP Traffic from ELB Security Group"
	vpc_id = aws_vpc.infra_mind_vpc.id

	ingress {
		description = "Allow 80 Port from ELB SG"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.infra_mind_elb_sg.id]
    }


    ingress {
        description = "Allow All Traffic from Ansible SG"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        security_groups = [aws_security_group.infra_mind_ansible_sg.id]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }


    tags = {
        Name = "InfraMindWordpressSG"
    }
}


resource "aws_instance" "infra_mind_wordpress_ec2" {
	ami = var.ami_id
	instance_type = var.instance_type
	key_name = var.key_name
	subnet_id = aws_subnet.infra_mind_public_subnet.id
	vpc_security_group_ids = [aws_security_group.infra_mind_wordpress_sg.id]
	tags =  {
        Name = "Wordpress"
    }

}

resource "aws_eip" "infra_mind_wordpress_ec2_eip" {
  instance = aws_instance.infra_mind_wordpress_ec2.id
  vpc      = true
}
