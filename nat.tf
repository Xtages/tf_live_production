
# nat gw
resource "aws_eip" "nat" {
  vpc = true
  tags = local.tags
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.main_public_1.id
  tags = local.tags
  depends_on    = [aws_internet_gateway.main_gw]
}

# VPC setup for NAT
resource "aws_route_table" "main_private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = local.tags
}

# route associations private
resource "aws_route_table_association" "main_private_1_a" {
  subnet_id      = aws_subnet.main_private_1.id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_private_2_a" {
  subnet_id      = aws_subnet.main_private_2.id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_private_3_a" {
  subnet_id      = aws_subnet.main_private_3.id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_private_4_a" {
  subnet_id      = aws_subnet.main_private_4.id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_private_5_a" {
  subnet_id      = aws_subnet.main_private_5.id
  route_table_id = aws_route_table.main_private.id
}

resource "aws_route_table_association" "main_private_6_a" {
  subnet_id      = aws_subnet.main_private_6.id
  route_table_id = aws_route_table.main_private.id
}

