
/* 
	Create a VPC with CIDR 172.17.0.0/16 from Variables.tf
*/



resource "aws_vpc" "infra_mind_vpc" {
  cidr_block  = var.infra_mind_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "InfraMindVPC"
  }
}


/* 
	Create an Internet Gateway and associate with VPC
*/

resource "aws_internet_gateway" "infra_mind_igw" {
  vpc_id = aws_vpc.infra_mind_vpc.id
  tags = {
    Name = "InfraMindIGW"
  }
}


/* 
	Create a Public Subnet
	map_public_ip_on_launch will be false because we will use Elastic IP
	Availability Zone will be assigned automatically
	The Public Subnet will be configured using Route Table 
*/


resource "aws_subnet" "infra_mind_public_subnet" {
  vpc_id = aws_vpc.infra_mind_vpc.id
  cidr_block = var.infra_mind_public_subnet_cidr
  availability_zone = var.availbility_zone_1
  map_public_ip_on_launch = false
  tags = {
    Name = "InfraMindPublicSubnet"
  }
}


/* 
	Create a Private Subnet
	Availability Zone will be assigned automatically
*/


resource "aws_subnet" "infra_mind_private_subnet" {
  vpc_id = aws_vpc.infra_mind_vpc.id
  cidr_block = var.infra_mind_private_subnet_cidr
  availability_zone = var.availbility_zone_2
  map_public_ip_on_launch = false
  tags = {
    Name = "InfraMindPrivateSubnet"
  }
}


/* 
	Create a Route Table with Internet Gateway and associate to the Public Subnet
*/


resource "aws_route_table" "public_route_table" {
	vpc_id = aws_vpc.infra_mind_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.infra_mind_igw.id
	}
	tags = {
    	Name = "InfraMindPublicRouteTable"
  	}
}


resource "aws_route_table_association" "public_route_table_association" {
	subnet_id  = aws_subnet.infra_mind_public_subnet.id
	route_table_id = aws_route_table.public_route_table.id
}


/* 
	We don't need to create any route table for Private Subnet, because it uses the main route table 
	which doesn't have any internet gateway route
*/




