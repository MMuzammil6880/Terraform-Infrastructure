

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  cidr   = var.vpc_cidr


  # Enable DNS hostnames and DNS resolution

  enable_dns_hostnames = true
  enable_dns_support   = true

  # Availability zones for the subnets
  azs = [var.availability_zone1, var.availability_zone2, var.availability_zone3]


  # Subnet configurations
  public_subnets  = [var.public_subnet1_cidr, var.public_subnet2_cidr, var.public_subnet3_cidr]
  private_subnets = [var.private_subnet1_cidr, var.private_subnet2_cidr, var.private_subnet3_cidr]


  # Enable NAT Gateway
  enable_nat_gateway = false
  single_nat_gateway = false

  # Enable VPC Flow Logs

  manage_default_route_table    = false
  manage_default_security_group = false


  # Tags for the VPC
  tags = {
    Name    = "${var.env_prefix}-vpc"
    managed = "${var.tf_tag}"
  }

  public_subnet_suffix = "${var.env_prefix}-public-subnet"
  private_subnet_suffix = "${var.env_prefix}-private-subnet"
  igw_tags = "${var.env_prefix}-igw"
  public_route_table_tags = "${var.env_prefix}-public-rtb"
  private_route_table_tags = "${var.env_prefix}-private-rtb"
}

