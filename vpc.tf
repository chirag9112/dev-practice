provider "aws" {
  region = "us-east-1"
}

# Create VPC
resource "aws_vpc" "my_vpc1" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC1"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw1" {
  vpc_id = aws_vpc.my_vpc1.id

  tags = {
    Name = "MyInternetGateway1"
  }
}

# Create Public Subnet
resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc1.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "PublicSubnet1"
  }
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.my_vpc1.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "PrivateSubnet"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw1.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Security Group
resource "aws_security_group" "my-sg" {
  vpc_id = aws_vpc.my_vpc1.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP traffic
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS traffic
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }

  tags = {
    Name = "my-sg"
  }
}

# Launch EC2 Instance in Public Subnet using direct resource reference for security group
resource "aws_instance" "my_ec21" {
  ami                   = "ami-0949b2d4323640e8c"
  instance_type         = "t2.micro"
  key_name              = "chirag_rsa"
  subnet_id             = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.my-sg.id]

  tags = {
    Name = "Batman_Instance1"
  }
}