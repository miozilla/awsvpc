# vpc sample template, customize accordingly.

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "DevDept-vnet" {
  cidr_block = "172.16.0.0/23"

  tags = {
    Name = "MySimpleVPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.DevDept-vnet.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.DevDept-vnet.id

  tags = {
    Name = "InternetGateway"
  }
}

resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.DevDept-vnet.id
  cidr_block        = "172.16.0.0/28"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.DevDept-vnet.id
  cidr_block        = "172.16.1.0/27"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet-b"
  }
}


resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.DevDept-vnet.id

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_subnet_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}