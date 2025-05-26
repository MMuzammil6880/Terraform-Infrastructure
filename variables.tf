variable "env_prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "customer"
}

variable "tf_tag" {
  description = "Tags for the VPC and its resources"
  type        = string
  default     = "managed-by-terraform"

}

variable "provider_region" {
  description = "this variable is for the provider region"
  type        = string
  default     = "us-east-1"

}

#================================ VPC =========================================
#below are the variables for the VPC [vpc.tf]
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet1_cidr" {
  description = "List of public subnets for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "public_subnet2_cidr" {
  description = "List of public subnets for the VPC"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet3_cidr" {
  description = "List of public subnets for the VPC"
  type        = string
  default     = "10.0.2.0/24"
}
variable "private_subnet1_cidr" {
  description = "List of private subnets for the VPC"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet2_cidr" {
  description = "List of private subnets for the VPC"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet3_cidr" {
  description = "List of private subnets for the VPC"
  type        = string
  default     = "10.0.5.0/24"
}





variable "availability_zone1" {
  description = "Availability zone for the first public subnet"
  type        = string
  default     = "us-east-1a"

}

variable "availability_zone2" {
  description = "Availability zone for the second public subnet"
  type        = string
  default     = "us-east-1b"

}

variable "availability_zone3" {
  description = "Availability zone for the private subnet"
  type        = string
  default     = "us-east-1c"

}

#================================ EC2 Instance =========================================
#below are the variables for the EC2 instance [ec2.tf]

variable "ec2_instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
  default     = "t3.medium"

}
#================================ Security Groups =========================================

#below are the variables for the frontend security group 

variable "wordpress_ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = string
    description = optional(string)
  }))
  default = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "sudo-vpn"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

#below are the variables for the RDS instance [rds.tf]
variable "db_engine" {
  description = "Database engine for the RDS instance"
  type        = string
  default     = "mysql"

}

variable "db_engine_version" {
  description = "Database engine version for the RDS instance"
  type        = string
  default     = "8.0"

}

variable "db_instance_type" {
  description = "Instance type for the RDS instance"
  type        = string
  default     = "db.t3.small"

}

variable "db_username" {
  description = "Username for the RDS instance"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Password for the RDS instance"
  type        = string
  default     = "WorPass123$%"
}

variable "db_storage_size" {
  description = "Storage size for the RDS instance"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "Port for the RDS instance"
  type        = number
  default     = 3306
}

variable "db_family" {
  description = "DB family for the RDS instance"
  type        = string
  default     = "mysql8.0"

}

variable "db_storage_type" {
  description = "Storage type for the RDS instance"
  type        = string
  default     = "gp2"

}


