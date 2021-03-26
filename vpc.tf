locals {
  tags = {
    owner = "Xtages"
    env = var.env
  }
}
# Internet VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  enable_classiclink   = "false"
  tags = local.tags
}

# Subnets
resource "aws_subnet" "main_public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.16.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = local.tags
}

resource "aws_subnet" "main_public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.48.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1b"
  tags = local.tags
}

resource "aws_subnet" "main_public_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.80.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1c"
  tags = local.tags
}

resource "aws_subnet" "main_public_4" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.112.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1d"
  tags = local.tags
}

resource "aws_subnet" "main_public_5" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.144.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1e"
  tags = local.tags
}

resource "aws_subnet" "main_public_6" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.176.0/21"
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1f"
  tags = local.tags
}

# Private subnets
resource "aws_subnet" "main_private_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1a"
  tags = local.tags
}

resource "aws_subnet" "main_private_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.32.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
  tags = local.tags
}

resource "aws_subnet" "main_private_3" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.64.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1c"
  tags = local.tags
}

resource "aws_subnet" "main_private_4" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.96.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1d"
  tags = local.tags
}

resource "aws_subnet" "main_private_5" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.128.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1e"
  tags = local.tags
}

resource "aws_subnet" "main_private_6" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.160.0/20"
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1f"
  tags = local.tags
}

# Internet GW
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.main.id

  tags = local.tags
}

# route tables
resource "aws_route_table" "main_public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_gw.id
  }

  tags = local.tags
}

# route associations public
resource "aws_route_table_association" "main_public_1_a" {
  subnet_id      = aws_subnet.main_public_1.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_public_2_a" {
  subnet_id      = aws_subnet.main_public_2.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_public_3_a" {
  subnet_id      = aws_subnet.main_public_3.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_public_4_a" {
  subnet_id      = aws_subnet.main_public_4.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_public_5_a" {
  subnet_id      = aws_subnet.main_public_5.id
  route_table_id = aws_route_table.main_public.id
}

resource "aws_route_table_association" "main_public_6_a" {
  subnet_id      = aws_subnet.main_public_6.id
  route_table_id = aws_route_table.main_public.id
}

