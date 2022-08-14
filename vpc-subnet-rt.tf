resource "aws_vpc" "jobnav2022_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "jobnav2022-vpc"
  }
}
resource "aws_subnet" "jobnav2022_subnet_pvt_1a" {
  vpc_id            = aws_vpc.jobnav2022_vpc.id
  cidr_block        = "10.0.0.0/28"
  availability_zone = "${var.aws_region}a"

  tags = {
    Name = "private-subnet-1a"
  }
  depends_on = [
    aws_vpc.jobnav2022_vpc
  ]
}
resource "aws_subnet" "jobnav2022_subnet_pvt_1c" {
  vpc_id            = aws_vpc.jobnav2022_vpc.id
  cidr_block        = "10.0.0.16/28"
  availability_zone = "${var.aws_region}c"

  tags = {
    Name = "private-subnet-1c"
  }
  depends_on = [
    aws_vpc.jobnav2022_vpc
  ]
}
resource "aws_subnet" "jobnav2022_subnet_pub_1a" {
  vpc_id            = aws_vpc.jobnav2022_vpc.id
  cidr_block        = "10.0.0.32/28"
  availability_zone = "${var.aws_region}a"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a"
  }
  depends_on = [
    aws_vpc.jobnav2022_vpc
  ]
}
resource "aws_subnet" "jobnav2022_subnet_pub_1c" {
  vpc_id            = aws_vpc.jobnav2022_vpc.id
  cidr_block        = "10.0.0.48/28"
  availability_zone = "${var.aws_region}c"
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1a"
  }
  depends_on = [
    aws_vpc.jobnav2022_vpc
  ]
}
resource "aws_db_subnet_group" "jobanv2022_subnet_region_pvt" {
  name       = "jobanv2022_subnet_${var.aws_region}_pvt"
  subnet_ids = [aws_subnet.jobnav2022_subnet_pvt_1a.id, aws_subnet.jobnav2022_subnet_pvt_1c.id]

  tags = {
    Name = "Subnet Group for ${var.aws_region}c subnets "
  }
}
resource "aws_db_subnet_group" "jobanv2022_subnet_region_pub" {
  name       = "jobanv2022_subnet_grp_${var.aws_region}_pub"
  subnet_ids = [aws_subnet.jobnav2022_subnet_pub_1a.id, aws_subnet.jobnav2022_subnet_pub_1c.id]

  tags = {
    Name = "Subnet Group for ${var.aws_region}pub subnets "
  }
}