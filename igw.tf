resource "aws_internet_gateway" "jobnav2022_igw" {
  vpc_id = aws_vpc.jobnav2022_vpc.id
  tags   = {
    Name = "jobnav2022_igw"
  }
  depends_on = [
    aws_vpc.jobnav2022_vpc
  ]
}