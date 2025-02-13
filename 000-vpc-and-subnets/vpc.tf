# Description: This Terraform configuration file creates a VPC with 2 public and 2 private subnets. 
# The public subnets are associated with an internet gateway and a route table that routes traffic to the internet gateway. 
# The private subnets are not associated with an internet gateway and are not routable to the internet.
resource "aws_vpc" "sample_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "sample_vpc"
  }
}

# create 2 public and 2 private subnets for HA
resource "aws_subnet" "sample_public_subnet_1" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "public subnet 1"
  }
}

resource "aws_subnet" "sample_public_subnet_2" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "public subnet 2"
  }
}

resource "aws_subnet" "sample_private_subnet_1" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "private subnet 1"
  }
}

resource "aws_subnet" "sample_private_subnet_2" {
  cidr_block = "10.0.4.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
  tags = {
    "Name" : "private subnet 2"
  }
}

# add a single internet gateway
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
}

# add a single route table
resource "aws_route_table" "sample_public_route_table" {
  vpc_id = aws_vpc.sample_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
}

# associate route table with public subnet 1
resource "aws_route_table_association" "public_route_table_association_1" {
  subnet_id      = aws_subnet.sample_public_subnet_1.id
  route_table_id = aws_route_table.sample_public_route_table.id
}

# associate route table with public subnet 2
resource "aws_route_table_association" "public_route_table_association_2" {
  subnet_id      = aws_subnet.sample_public_subnet_2.id
  route_table_id = aws_route_table.sample_public_route_table.id
}
