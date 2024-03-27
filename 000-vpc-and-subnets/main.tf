terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-3"
}

# create VPC
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
}

resource "aws_subnet" "sample_public_subnet_2" {
  cidr_block = "10.0.2.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
}

resource "aws_subnet" "sample_private_subnet_1" {
  cidr_block = "10.0.3.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
}

resource "aws_subnet" "sample_private_subnet_2" {
  cidr_block = "10.0.4.0/24"
  vpc_id     = aws_vpc.sample_vpc.id
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
