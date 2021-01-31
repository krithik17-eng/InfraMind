resource "aws_eip" "infra_mind_nat_eip" {
  vpc        = true
}

resource "aws_nat_gateway" "infra_mind_nat_gw" {
	allocation_id = aws_eip.infra_mind_nat_eip.id
	subnet_id = aws_subnet.infra_mind_public_subnet.id
	tags = {
    Name = "InfraMindNatGW"
  }
}


resource "aws_route_table" "private_route_table" {
	vpc_id = aws_vpc.infra_mind_vpc.id
	route {
		cidr_block = "0.0.0.0/0"
		nat_gateway_id = aws_nat_gateway.infra_mind_nat_gw.id
	}
	tags = {
    	Name = "InfraMindPrivateRouteTable"
  	}
}

resource "aws_route_table_association" "private_route_table_association" {
	subnet_id  = aws_subnet.infra_mind_private_subnet.id
	route_table_id = aws_route_table.private_route_table.id
}

