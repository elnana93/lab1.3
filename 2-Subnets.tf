#These are   for  public

resource "aws_subnet" "public-us-west-2a" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.50.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-west-2a"
  }

}

resource "aws_subnet" "public-us-west-2b" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.50.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-west-2b"
  }
}


resource "aws_subnet" "public-us-west-2c" {
  vpc_id                  = aws_vpc.app1.id
  cidr_block              = "10.50.3.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-us-west-2c"
  }

}

#these are for private
resource "aws_subnet" "private-us-west-2a" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.50.11.0/24"
  availability_zone = "us-west-2a" #us-west-2a, us-west-2b, us-west-2c

  tags = {
    Name = "private-us-west-2a"
  }

}

resource "aws_subnet" "private-us-west-2b" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.50.12.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "private-us-west-2b"
  }

}


resource "aws_subnet" "private-us-west-2c" {
  vpc_id            = aws_vpc.app1.id
  cidr_block        = "10.50.13.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "private-us-west-2c"
  }

}