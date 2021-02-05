

resource "aws_security_group" "infra_mind_mysql_sg" {
	
    name = "InfraMindMySQLSG"
    description = "Allow MYSQL Traffic from Wordpress EC2 Security Group"

    ingress {
    	description = "Allow 3306 Port from Wordpress SG"
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = [aws_security_group.infra_mind_wordpress_sg.id]
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

	vpc_id = aws_vpc.infra_mind_vpc.id

    tags = {
        Name = "InfraMindMySQLSG"
    }
}


resource "aws_instance" "infra_mind_mysql_ec2" {
	ami = var.ami_id
	instance_type = var.instance_type
	key_name = var.key_name
	subnet_id = aws_subnet.infra_mind_private_subnet.id
	vpc_security_group_ids = [aws_security_group.infra_mind_mysql_sg.id]

	tags = {
        Name = "MySQL"
    }

}