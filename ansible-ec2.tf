

resource "aws_security_group" "infra_mind_ansible_sg" {
	
    name = "InfraMindAnsibleSG"
    description = "Allow SSH Traffic from the Internet"
    vpc_id = aws_vpc.infra_mind_vpc.id

	ingress {
		description = "Allow 22 Port from the Internet"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    

    tags = {
        Name = "InfraMindAnsibleSG"
    }
}


resource "aws_instance" "infra_mind_ansible_ec2" {

	ami = var.ami_id
	instance_type = var.instance_type
	key_name = var.key_name
	subnet_id = aws_subnet.infra_mind_public_subnet.id
	vpc_security_group_ids = [aws_security_group.infra_mind_ansible_sg.id]
    
    user_data = << EOF
        #! /bin/bash
        sudo apt update
        sudo apt install software-properties-common
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt install ansible
    EOF
    
	tags =  {
        Name = "Ansible"
    }
}

resource "aws_eip" "infra_mind_ansible_ec2_eip" {
  instance = aws_instance.infra_mind_ansible_ec2.id
  vpc      = true
}

