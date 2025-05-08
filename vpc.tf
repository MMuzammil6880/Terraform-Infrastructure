module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  cidr   = var.vpc_cidr

 
  # Enable DNS hostnames and DNS resolution

  enable_dns_hostnames = true
  enable_dns_support   = true

  manage_default_route_table         = false
  manage_default_security_group      = false  
  
  # Tags for the VPC and its resources
  tags = {
    Name   = "${var.env_prefix}-vpc"
    managed = "${var.tf_tag}"
  }
}

#========= Below are the Subnets ==============


# Public Subnet
resource "aws_subnet" "public1" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.public_subnet1_cidr
    availability_zone       = var.availability_zone1
    map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet1"
    managed = "${var.tf_tag}"
  }
  
}

resource "aws_subnet" "public2" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.public_subnet2_cidr
    availability_zone       = var.availability_zone2
    map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet2"
    managed = "${var.tf_tag}"
  }
  
}

resource "aws_subnet" "public3" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.public_subnet3_cidr
    availability_zone       = var.availability_zone2
    map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_prefix}-public-subnet3"
    managed = "${var.tf_tag}"
  }
  
}

# Private Subnet 

resource "aws_subnet" "private1" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.private_subnet1_cidr
    availability_zone       = var.availability_zone3
    map_public_ip_on_launch = false

  tags = {
    Name = "${var.env_prefix}-private-subnet1"
    managed = "${var.tf_tag}"
  }
}

resource "aws_subnet" "private2" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.private_subnet2_cidr
    availability_zone       = var.availability_zone3
    map_public_ip_on_launch = false

  tags = {
    Name = "${var.env_prefix}-private-subnet2"
    managed = "${var.tf_tag}"
  }
}

resource "aws_subnet" "private3" {
    vpc_id                  = module.vpc.vpc_id
    cidr_block              = var.private_subnet3_cidr
    availability_zone       = var.availability_zone3
    map_public_ip_on_launch = false

  tags = {
    Name = "${var.env_prefix}-private-subnet3"
    managed = "${var.tf_tag}"
  }
}

# ======== Internet Gateway ==============

resource "aws_internet_gateway" "igw" {
  vpc_id = module.vpc.vpc_id


  tags = {
    Name = "${var.env_prefix}-igw"
    managed = "${var.tf_tag}"
  }
}


# ======== Route Tables ==============

# Public Route Table
# This route table will route traffic to the Internet Gateway for public subnets

resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env_prefix}-public-rt"
    managed = "${var.tf_tag}"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public" {

# This will create a route table association for each public subnet
# using a for_each loop

   for_each = {
    public1 = aws_subnet.public1.id
    public2 = aws_subnet.public2.id
    public3 = aws_subnet.public3.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.public.id
}

# Private Route Table
# This route table will route traffic to the NAT Gateway for internet access

resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${var.env_prefix}-private-rt"
    managed = "${var.tf_tag}"
  }
}

# Private Route Table Association

resource "aws_route_table_association" "private" {
    for_each = {
    public1 = aws_subnet.private1.id
    public2 = aws_subnet.private2.id
    public3 = aws_subnet.private3.id
  }

  subnet_id      = each.value
  route_table_id = aws_route_table.private.id
}