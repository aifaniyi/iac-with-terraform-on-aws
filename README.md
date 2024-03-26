# IaC with Terraform on AWS

A series of IaC projects provisioning AWS infrastruture using Terraform

## 000-vpc-and-subnets

Provisions an AWS VPC (cidr - 10.0.0.0/24) conatining 2 subnets (one public 10.0.1.0/24 and one private 10.0.2.0/24). It adds an internet gateway and a route table for the public subnet. And finally includes a route table association to connect the public subnet to the route table.
