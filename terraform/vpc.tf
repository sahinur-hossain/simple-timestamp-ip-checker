
# VPC & Subnets
resource "aws_vpc" "app_vpc" {
  cidr_block = "11.11.0.0/24"

  tags = {
    Name = "app-vpc"
    Env  = "TaskEnv"
  }
}

resource "aws_subnet" "public1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "11.11.0.0/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "11.11.0.64/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Public Subnet 2"
  }
}

resource "aws_subnet" "private1" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "11.11.0.128/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private2" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "11.11.0.192/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "Private Subnet 2"
  }
}

# Route Tables

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "Public Route Table"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "Private Route Table"
  }
}

# Route Table Associations

resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private1_assoc" {
  subnet_id      = aws_subnet.private1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private2_assoc" {
  subnet_id      = aws_subnet.private2.id
  route_table_id = aws_route_table.private_rt.id
}

# IGW and Public Route table configuration  
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "App IGW"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# NAT and private Route table configuration
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "NAT EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public1.id

  tags = {
    Name = "App NAT Gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

