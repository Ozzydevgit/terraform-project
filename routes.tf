resource "aws_route_table" "public_rt" {
  count  = length(var.az)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-route-table-${count.index}"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(var.az)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_rt[count.index].id
}
