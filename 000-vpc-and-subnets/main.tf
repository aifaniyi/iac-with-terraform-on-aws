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

# create public and private subnets
resource "aws_subnet" "sample_public_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.sample_vpc.id
}

resource "aws_subnet" "sample_private_subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.sample_vpc.id
}

# add internet gateway
resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id
}

# add a route table
resource "aws_route_table" "sample_public_route_table" {
  vpc_id = aws_vpc.sample_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }
}

# associate route table with public subnet
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id = aws_subnet.sample_public_subnet.id
  route_table_id = aws_route_table.sample_public_route_table.id
}
