resource "aws_subnet" "public_subnets" {
  count = length(var.az)
  
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.az, count.index)
  cidr_block        = element(var.cidr_block, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    var.subnet_tags,
    {
      Name = "public-subnet-${count.index}"
    }
  )
}