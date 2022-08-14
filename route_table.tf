resource "aws_route_table" "jobnav2022_route_table_pvt" {
  vpc_id = aws_vpc.jobnav2022_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.jobnav2022_nat_gw.id
  }
  tags = {
    Name = "jobnav2022_pvt_route_table"
  }
}
resource "aws_route_table" "jobnav2022_route_table_pub" {
  vpc_id = aws_vpc.jobnav2022_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jobnav2022_igw.id
  }
  tags = {
    Name = "jobnav2022_pub_route_table"
  }
}
resource "aws_route_table_association" "rt_association_pvt_1a" {
  subnet_id      = aws_subnet.jobnav2022_subnet_pvt_1a.id
  route_table_id = aws_route_table.jobnav2022_route_table_pvt.id
}
resource "aws_route_table_association" "rt_association_pvt_1c" {
  subnet_id      = aws_subnet.jobnav2022_subnet_pvt_1c.id
  route_table_id = aws_route_table.jobnav2022_route_table_pvt.id
}
resource "aws_route_table_association" "rt_association_pub_1a" {
  subnet_id      = aws_subnet.jobnav2022_subnet_pub_1a.id
  route_table_id = aws_route_table.jobnav2022_route_table_pub.id
}
resource "aws_route_table_association" "rt_association_pub_1c" {
  subnet_id      = aws_subnet.jobnav2022_subnet_pub_1c.id
  route_table_id = aws_route_table.jobnav2022_route_table_pub.id
}
