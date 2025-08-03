
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "nat"
  }
}


#You need a public sebnet for a NAT in order to talk to the internet
#A private subnet won't work because it doesnt have route to the Internet Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public-us-west-2b.id

  tags = {
    Name = "nat"
  }

  depends_on = [aws_internet_gateway.igw]
}
