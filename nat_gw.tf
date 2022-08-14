resource "aws_eip" "jobnav2022_eip_ngw" { 
    vpc  = true
    tags = {
        Name = "jobnav2022_eip_nat_gateway"
    }
    lifecycle {
        prevent_destroy = false
    }
}
resource "aws_nat_gateway" "jobnav2022_nat_gw" {
  allocation_id = aws_eip.jobnav2022_eip_ngw.id
  subnet_id     = aws_subnet.jobnav2022_subnet_pub_1a.id

  tags = {
    Name = "jobnav2022_natgw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [
      aws_internet_gateway.jobnav2022_igw
    ]
}